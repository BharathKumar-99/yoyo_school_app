import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../../config/constants/constants.dart';
import '../../../config/utils/get_user_details.dart';
import '../../../config/utils/global_loader.dart';
import '../data/try_phrases_repo.dart';

class TryPhrasesProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  bool showPhrase = true;
  Language? language;
  int? streak;
  final TryPhrasesRepo _repo = TryPhrasesRepo();
  final AudioPlayer audioManager = AudioPlayer();
  UserResult? result;
  bool isLoading = true;
  bool _disposed = false;
  bool isLast;
  bool showStreakVal = false;

  TryPhrasesProvider(this.phraseModel, this.streak, this.isLast) {
    initAudio();
  }

  @override
  void dispose() {
    _disposed = true;
    audioManager.dispose();
    super.dispose();
  }

  void safeNotify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> initAudio() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

    try {
      language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      rethrow;
    }

    try {
      result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      rethrow;
    }

    try {
      await audioManager.setVolume(1);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      rethrow;
    }

    try {
      await upsertResult(listen: false);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      rethrow;
    }

    isLoading = false;
    safeNotify();

    try {
      await audioManager.setUrl(phraseModel.recording ?? "");
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      rethrow;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());

    await playAudio();
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
      rethrow;
    }
  }

  Future<void> upsertResult({bool listen = true}) async {
    try {
      final userId = GetUserDetails.getCurrentUserId() ?? "";

      result ??= UserResult(
        userId: userId,
        phrasesId: phraseModel.id,
        type: Constants.learned,
      );

      if (listen) {
        result?.listen = (result?.listen ?? 0) + 1;
      }

      result = await _repo.upsertResult(result!);
    } catch (e) {
      rethrow;
    }
  }

  void showStreak() {
    showStreakVal = true;
    notifyListeners();
  }

  void togglePhrase() {
    showPhrase = !showPhrase;
    safeNotify();
  }
}
