import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';

import '../model/level_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  final HomeRepository homeRepository;
  List<Level>? levels = [];
  Student? userClases;
  Student? student;
  int totalPhrases = 0;
  int atemptedPhrases = 0;
  StreamSubscription<Student?>? _studentSubscription;

  HomeScreenProvider(this.homeRepository) {
    init();
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    userClases = await homeRepository.getClasses();
    levels = await homeRepository.getLevel();
    _subscribeToStudentData();
    atemptedPhrases = await homeRepository.getTotalAtemptedPhrases();
    userClases?.classes?.school?.schoolLanguage?.forEach((val) {
      totalPhrases += val.language?.phrase?.length ?? 0;
    });
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  void _subscribeToStudentData() {
    _studentSubscription = homeRepository.getUserDataStream().listen(
      (studentdata) async {
        if (studentdata == null) return;
        student = studentdata;
        atemptedPhrases = await homeRepository.getTotalAtemptedPhrases();
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Student stream error: $error');
      },
    );
  }

  @override
  void dispose() {
    _studentSubscription?.cancel();
    super.dispose();
  }
}
