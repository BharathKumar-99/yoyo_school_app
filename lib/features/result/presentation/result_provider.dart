import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/data/results_repo.dart';
import 'package:yoyo_school_app/features/result/model/remote_config_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../model/speech_evaluation_model.dart';

class ResultProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  Language language;
  late UserResult? result;
  late RemoteConfig apiCred;
  SpeechEvaluationModel? speechEvaluationModel;
  String resultTest = text.notAttemptText;
  String audioPath;
  final ResultsRepo _repo = ResultsRepo();

  ResultProvider(this.phraseModel, this.audioPath, this.language) {
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    speechEvaluationModel = await _repo.callSuperSpeechApi(
      audioPath: audioPath,
      audioCode: language.launguageCode ?? "",
      phrase: phraseModel.phrase ?? "",
    );
    await upsertResult(
      speechEvaluationModel?.result?.overall ?? 0,
      submit: false,
    );
    if ((result?.attempt ?? 0) >= 0) {
      if ((result?.score ?? 0) >
          (speechEvaluationModel?.result?.overall ?? 0)) {
        resultTest =
            '${text.improvedBy}${(result?.score ?? 0) - (speechEvaluationModel?.result?.overall ?? 0)}%!';
      } else {
        resultTest = text.noImporove;
      }
    }
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  Future<void> upsertResult(int score, {bool submit = false}) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";

    result ??= UserResult(userId: userId, phrasesId: phraseModel.id);

    result?.score = score;
    result?.scoreSubmitted = submit;
    result?.attempt = (result?.attempt ?? 0) + 1;

    result = await _repo.upsertResult(result!);
    if (submit) {
      NavigationHelper.go(RouteNames.home);
    }
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
