import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/data/results_repo.dart';
import 'package:yoyo_school_app/features/result/model/remote_config_model.dart';

import '../model/speech_evaluation_model.dart';

class ResultProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  Language language;
  late RemoteConfig apiCred;
  SpeechEvaluationModel? speechEvaluationModel;

  String audioPath;
  final ResultsRepo _repo = ResultsRepo();

  ResultProvider(this.phraseModel, this.audioPath, this.language) {
    init();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    speechEvaluationModel = await _repo.callSuperSpeechApi(
      audioPath: audioPath,
      audioCode: 'sp',
      phrase: phraseModel.phrase ?? "",
    );
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }
}
