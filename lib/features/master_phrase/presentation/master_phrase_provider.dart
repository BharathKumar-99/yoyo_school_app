import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/master_phrase/data/master_phrase_repo.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';
import '../../home/model/phrases_model.dart';

class MasterPhraseProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  final MasterPhraseRepo _repo = MasterPhraseRepo();
  Language? language;
  late UserResult? result;
  final AudioPlayer audioManager = AudioPlayer();
  final AudioPlayer audioManagerQuestion = AudioPlayer();
  bool isLoading = true;
  bool showStreakVal = false;
  int categories;
  MasterPhraseProvider(this.phraseModel, this.categories) {
    init();
  }

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

    try {
      language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
    } catch (e) {
      throw "Failed to load language data";
    }

    try {
      result = await _repo.getAttemptedPhrase(
        phraseModel.id ?? 0,
        Constants.mastered,
      );
    } catch (e) {
      throw "Failed to load phrase result";
    }

    try {
      await upsertResult(listen: false);
    } catch (e) {
      throw "Failed to update phrase status";
    }

    try {
      await audioManager.setUrl(phraseModel.recording ?? "");
      if (phraseModel.questionRecording != null) {
        await audioManagerQuestion.setUrl(phraseModel.questionRecording ?? "");
      }
    } catch (e) {
      throw "Failed to load audio file";
    }

    try {
      await audioManager.setVolume(1);
      await audioManagerQuestion.setVolume(1);
    } catch (e) {
      throw "Failed to set audio volume";
    }

    isLoading = false;
    notifyListeners();

    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    if (phraseModel.questions != null) {
      await playQuestionAudio();
    }
  }

  Future<void> upsertResult({bool listen = true}) async {
    try {
      final userId = GetUserDetails.getCurrentUserId() ?? "";

      result ??= UserResult(
        userId: userId,
        phrasesId: phraseModel.id,
        type: Constants.mastered,
      );

      result = await _repo.upsertResult(result!);
    } catch (e) {
      throw "Failed to save phrase result";
    }
  }

  Future<void> playAudio() async {
    try {
      final player = audioManager;

      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      await player.play();
      await upsertResult();
    } catch (e) {
      throw "Audio playback failed";
    }
  }

  void showStreak() {
    showStreakVal = true;
    notifyListeners();
  }

  Future<void> playQuestionAudio() async {
    try {
      final player = audioManagerQuestion;

      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      await player.play();
      await upsertResult();
    } catch (e) {
      throw "Audio playback failed";
    }
  }
}
