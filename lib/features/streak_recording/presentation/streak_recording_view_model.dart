import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/features/common/data/global_repo.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/school_launguage.dart';
import 'package:yoyo_school_app/features/result/data/results_repo.dart';

import '../../home/model/language_model.dart';
import '../../home/model/phrases_model.dart';
import '../../home/model/student_model.dart';
import '../../result/model/speech_evaluation_model.dart';
import '../../result/model/user_result_model.dart';

class StreakRecordingViewModel extends ChangeNotifier {
  final PhraseModel phraseModel;
  final Language language;
  final String audioPath;
  late UserResult? result;
  Student? userClases;
  List<Level>? levels = [];
  int streak;
  String form;
  bool isLast;
  SchoolLanguage? slanguage;
  bool loading = true;
  int score = 0;
  SpeechEvaluationModel? speechEvaluationModel;
  final ResultsRepo _repo = ResultsRepo();
  final GlobalRepo _globalRepo = GlobalRepo();
  StreakRecordingViewModel(
    this.phraseModel,
    this.audioPath,
    this.language,
    this.streak,
    this.form,
    this.isLast,
  ) {
    init();
  }

  init() async {
    loading = true;
    notifyListeners();
    result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    userClases = await _repo.getClasses();
    speechEvaluationModel = await _globalRepo.callSuperSpeechApi(
      audioPath: audioPath,
      audioCode: language.launguageCode ?? "",
      phrase: phraseModel.phrase ?? "",
    );
    score = 85; // speechEvaluationModel?.result?.overall ?? 0;
    slanguage = userClases?.classes?.school?.schoolLanguage?.firstWhere(
      (val) => val.language?.id == language.id,
    );
    levels = await _repo.getLevel();

    await upsertResult(score, submit: score > Constants.minimumSubmitScore);

    loading = false;
    notifyListeners();

    Future.delayed(Duration(seconds: 3), () {
      if (score > Constants.minimumSubmitScore && !isLast) {
        NavigationHelper.pushReplacement(
          RouteNames.phrasesDetails,
          extra: {
            'language': slanguage,
            "className": userClases?.classes?.className ?? "",
            "level": levels ?? [],
            'student': userClases,
            'next': true,
            'from': form,
            "streak": streak + 1,
            "phraseId": phraseModel.id,
          },
        );
      } else {
        ctx!.pop();
        NavigationHelper.push(
          form == 'new' ? RouteNames.result : RouteNames.masterResult,
          extra: {
            'phraseModel': phraseModel,
            'path': audioPath,
            'language': language,
            'isLast': isLast,
          },
        );
      }
    });
  }

  Future<void> upsertResult(int score, {bool submit = false}) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    List<String> goodWords = result?.goodWords ?? [];
    List<String> badWords = result?.badWords ?? [];
    if (speechEvaluationModel?.result?.words?.isNotEmpty ?? false) {
      goodWords.clear();
      badWords.clear();
    }

    speechEvaluationModel?.result?.words?.forEach((val) {
      if (getWordColor(val.scores?.overall ?? 0) == Colors.green) {
        goodWords.add(val.word ?? "");
      } else if (getWordColor(val.scores?.overall ?? 0) == Colors.redAccent) {
        badWords.add(val.word ?? "");
      }
    });

    result ??= UserResult(
      userId: userId,
      phrasesId: phraseModel.id,
      type: Constants.learned,
    );
    result?.score = score;
    result?.scoreSubmitted = submit;
    result?.goodWords = goodWords;
    result?.badWords = badWords;
    result?.attempt = (result?.attempt ?? 0) + 1;
    result?.vocab = goodWords.length;
    result = await _repo.upsertResult(result!);
    await _globalRepo.updateStreak(language.id, userId, streak);
  }

  Color getWordColor(int score) {
    switch (score) {
      case > Constants.minimumWordScoreleft &&
          < Constants.minimumWordScoreright:
        return Colors.grey;
      case < Constants.minimumWordScoreleft:
        return Colors.redAccent;
      case > Constants.minimumWordScoreright:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
