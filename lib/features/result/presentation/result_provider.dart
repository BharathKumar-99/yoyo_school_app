import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/features/common/data/global_repo.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/data/results_repo.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';
import '../../home/model/level_model.dart';
import '../../home/model/school_launguage.dart';
import '../../home/model/student_model.dart';
import '../model/speech_evaluation_model.dart';

class ResultProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  Language language;
  late UserResult? result;
  SchoolLanguage? slanguage;
  ChatGptResponse? tableResponse;
  ChatGptResponse? gptResponse;
  SpeechEvaluationModel? speechEvaluationModel;
  int currentHigest = 0;
  final GlobalRepo _globalRepo = GlobalRepo();
  final ResultsRepo _repo = ResultsRepo();

  String audioPath;
  int score = 0;
  Student? userClases;
  List<Level>? levels = [];

  late GlobalProvider globalProvider;

  bool showRivePopup = false;

  ResultProvider(this.phraseModel, this.audioPath, this.language) {
    globalProvider = Provider.of<GlobalProvider>(ctx!, listen: false);
    init();
  }

  Future<void> init() async {
    try {
      result = await _safe(
        () => _repo.getAttemptedPhrase(phraseModel.id ?? 0),
        "Failed to load phrase result",
      );
      currentHigest = result?.highestScore ?? 0;
      userClases = await _safe(
        () => _repo.getClasses(),
        "Failed to load class details",
      );

      speechEvaluationModel = await _safe(
        () => _globalRepo.callSuperSpeechApi(
          audioPath: audioPath,
          audioCode: language.launguageCode ?? "",
          phrase: phraseModel.phrase ?? "",
        ),
        "Speech evaluation failed",
      );

      score = 92;
      speechEvaluationModel?.result?.overall ?? 0;

      tableResponse = await _globalRepo.getRandomFeedback(score);
      if (score >= 80) {
        gptResponse = await _safe(
          () => _globalRepo.getSpeechFeedback(speechEvaluationModel!),
          "Failed to get feedback",
        );
      }

      slanguage = userClases?.classes?.school?.schoolLanguage?.firstWhere(
        (val) => val.language?.id == language.id,
        orElse: () => throw "Language not found in school list",
      );

      levels = await _safe(
        () async => _repo.getLevel(),
        "Failed to load level data",
      );

      await _safe(
        () => upsertResult(
          score,
          submit:
              (score > Constants.lowScreenScore &&
              (score > Constants.minimumSubmitScore ||
                  (phraseModel.readingPhrase == true))),
        ),
        "Failed to save result",
      );

      notifyListeners();
    } catch (_) {}
  }

  Future<T> _safe<T>(Future<T> Function() call, String errorMessage) async {
    try {
      return await call();
    } catch (e) {
      throw errorMessage;
    }
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
    try {
      final userId = GetUserDetails.getCurrentUserId() ?? "";

      List<String> goodWords = result?.goodWords ?? [];
      List<String> badWords = result?.badWords ?? [];

      if (speechEvaluationModel?.result?.words?.isNotEmpty ?? false) {
        goodWords = [];
        badWords = [];
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
      if ((result?.highestScore ?? 0) < score) {
        result?.highestScore = score;
      }
      result?.scoreSubmitted = submit;
      result?.goodWords = goodWords;
      result?.badWords = badWords;
      result?.attempt = (result?.attempt ?? 0) + 1;
      result?.vocab = goodWords.length;

      result = await _repo.upsertResult(result!);
    } catch (e) {
      throw "Failed to update result";
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

  String getReadingPhrase() {
    String text = '';
    String preText = ((currentHigest) < (result?.score ?? 0))
        ? 'you have imporoved ${result?.score} is your new best score'
        : 'You’re only ${(result?.score ?? 0) - (currentHigest)}% off your previous best score';
    text = preText;
    return text;
  }
}
