import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';

import '../../../config/router/navigation_helper.dart';
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
    init();
  }

  Future<void> init() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

      userClases = await homeRepository.getClasses();
      if (userClases == null) {
        throw "Could not load classes";
      }

      levels = await homeRepository.getLevel();
      if (levels == null) {
        throw "Could not load levels";
      }

      _subscribeToStudentData();

      atemptedPhrases = await homeRepository.getTotalAtemptedPhrases();

      totalPhrases = 0;
      userClases?.classes?.school?.schoolLanguage?.forEach((val) {
        totalPhrases += val.language?.phrase?.length ?? 0;
      });

      notifyListeners();
    } catch (e) {
      throw Exception("Home initialization failed: $e");
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }
  }

  void _subscribeToStudentData() {
    try {
      _studentSubscription = homeRepository.getUserDataStream().listen(
        (studentdata) async {
          try {
            if (studentdata == null) return;
            student = studentdata;

            atemptedPhrases = await homeRepository.getTotalAtemptedPhrases();
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
