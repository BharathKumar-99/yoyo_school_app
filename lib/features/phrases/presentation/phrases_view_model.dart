import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/attempt_phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/phrases/data/phrases_deatils_repo.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../home/model/school_launguage.dart';

class PhrasesViewModel extends ChangeNotifier {
  final SchoolLanguage classes;
  final PhrasesDeatilsRepo _repo = PhrasesDeatilsRepo();
  List<UserResult>? userResult = [];
  List<AttemptedPhrase>? attemptedPhrase;
  final Student? student;
  int classPercentage = 0;
  int userPercentage = 0;
  List<int> classesScore = [];
  List<int> userScore = [];

  PhrasesViewModel(this.classes, this.student) {
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    List<int> ids = [];
    classes.language?.phrase?.forEach((val) => ids.add(val.id ?? 0));
    userResult = await _repo.getAllUserResults(ids);
    attemptedPhrase = await _repo.getRecordedPhrases(
      classes.language?.id ?? 0,
      student?.id ?? 0,
      userResult?.where((val) => val.userId == userId).toList() ?? [],
    );
    userResult?.forEach((val) {
      if (ids.contains(val.phrasesId)) {
        classesScore.add(val.score ?? 0);
        if (val.userId == userId) {
          userScore.add(val.score ?? 0);
        }
      }
    });

    int classStrength = student?.classes?.noOfStudents ?? 0;
    classPercentage = (classesScore.reduce((a, b) => a + b) / classStrength)
        .round();
    int phraseLength = classes.language?.phrase?.length ?? 0;
    userPercentage = (userScore.reduce((a, b) => a + b) / phraseLength).round();

    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }
}
