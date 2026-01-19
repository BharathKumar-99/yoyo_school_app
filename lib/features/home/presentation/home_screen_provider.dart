import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/student_classes.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';

import '../../../config/router/navigation_helper.dart';
import '../../common/presentation/global_provider.dart';
import '../model/level_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  final HomeRepository homeRepository;
  List<Level>? levels = [];
  Student? userClases;
  Student? student;
  int totalPhrases = 0;
  int atemptedPhrases = 0;
  StreamSubscription<Student?>? _studentSubscription;
  ProfileProvider? _profileProvider;

  HomeScreenProvider(this.homeRepository) {
    _profileProvider = Provider.of<ProfileProvider>(ctx!, listen: false);
    _profileProvider?.initialize();
  }

  Future<bool> init() async {
    try {
      Provider.of<GlobalProvider>(ctx!, listen: false);
      userClases = await homeRepository.getClasses();
      if (userClases == null) {
        throw "Could not load classes";
      }

      levels = await homeRepository.getLevel();
      if (levels == null) {
        throw "Could not load levels";
      }

      totalPhrases = 0;
      userClases?.user?.studentClasses?.forEach((student) {
        totalPhrases += student.classes?.language?.phrase?.length ?? 0;
      });

      if (userClases?.user?.studentClasses?.length == 1) {
        NavigationHelper.go(
          RouteNames.phraseCategories,
          extra: {
            'language': userClases?.user?.studentClasses?.first.classes?.language,
            "className": userClases?.user?.studentClasses?.first.classes?.className,
            "level": levels,
            'student': userClases,
          },
        );
        return false;
      }
      _subscribeToStudentData();
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception("Home initialization failed: $e");
    }
  }

  void _subscribeToStudentData() {
    try {
      _studentSubscription = homeRepository.getUserDataStream().listen(
        (studentdata) async {
          try {
            if (studentdata == null) return;
            student = studentdata;
            List<int> ids = [];
            for (StudentClassesModel studentClasses
                in userClases?.user?.studentClasses ?? []) {
              for (PhraseModel phrase
                  in studentClasses.classes?.language?.phrase ?? []) {
                ids.add(phrase.id ?? 0);
              }
            }
            atemptedPhrases = await homeRepository.getTotalAtemptedPhrases(
              student?.id ?? 0,
              ids,
            );
            notifyListeners();
          } catch (e) {
            throw Exception("Failed to update student data: $e");
          }
        },
        onError: (error) {
          debugPrint("Student stream error: $error");
          throw Exception("Student stream crashed: $error");
        },
      );
    } catch (e) {
      throw Exception("Failed to subscribe to student stream: $e");
    }
  }

  @override
  void dispose() {
    _studentSubscription?.cancel();
    super.dispose();
  }
}
