import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/features/common/data/global_repo.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/school_launguage.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/result/model/remote_config_model.dart';
import 'package:yoyo_school_app/features/result/model/speech_evaluation_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../data/master_results_repo.dart';

class MasterResultProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  Language language;
  late UserResult? result;
  SchoolLanguage? slanguage;
  late RemoteConfig apiCred;
  SpeechEvaluationModel? speechEvaluationModel;
  ChatGptResponse? gptResponse;
  String audioPath;
  int score = 0;
  List<Level>? levels = [];
  final GlobalRepo _globalRepo = GlobalRepo();
  Student? userClases;
  final MasterResultsRepo _repo = MasterResultsRepo();
  bool showRivePopup = false;
  late GlobalProvider globalProvider;
  MasterResultProvider(this.phraseModel, this.audioPath, this.language) {
    globalProvider = Provider.of<GlobalProvider>(ctx!, listen: false);
    init();
  }

  init() async {
    result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    speechEvaluationModel = await _globalRepo.callSuperSpeechApi(
      audioPath: audioPath,
      audioCode: language.launguageCode ?? "",
      phrase: phraseModel.phrase ?? "",
    );
    score = speechEvaluationModel?.result?.overall ?? 0;
    userClases = await _repo.getClasses();
    levels = await _repo.getLevel();
    slanguage = userClases?.classes?.school?.schoolLanguage?.firstWhere(
      (val) => val.language?.id == language.id,
    );
    gptResponse = await _globalRepo.getSpeechFeedback(speechEvaluationModel!);
    await upsertResult(score, submit: score > Constants.minimumSubmitScore);

    notifyListeners();
  }

  void showAnimationPopup() {
    showRivePopup = true;
    notifyListeners();
  }

  void hideAnimationPopup() {
    showRivePopup = false;
    notifyListeners();
  }

  void onEvaluationComplete() {
    showAnimationPopup();
    Future.delayed(const Duration(seconds: 3), hideAnimationPopup);
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
      type: Constants.mastered,
    );
    result?.score = score;
    result?.scoreSubmitted = submit;
    result?.goodWords = goodWords;
    result?.badWords = badWords;
    result?.attempt = (result?.attempt ?? 0) + 1;
    result?.vocab = goodWords.length;
    result = await _repo.upsertResult(result!);
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
