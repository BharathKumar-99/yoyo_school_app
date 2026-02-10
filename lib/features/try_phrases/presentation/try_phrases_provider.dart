import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/core/audio/global_recording_state.dart';
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
  final AudioPlayer audioManagerQuestion = AudioPlayer();
  UserResult? result;
  bool isLoading = true;
  bool _disposed = false;
  bool isLast;
  bool showStreakVal = false;
  final int categories;
  bool showMoreTranslation = false;

  TryPhrasesProvider(
    this.phraseModel,
    this.streak,
    this.isLast,
    this.categories,
    BuildContext context,
  ) {
    initAudio(context);
  }

  @override
  void dispose() {
    _disposed = true;
    audioManager.dispose();
    audioManagerQuestion.dispose();
    super.dispose();
  }

  void safeNotify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> initAudio(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

    try {
      language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }

    try {
      result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }

    try {
      await audioManager.setVolume(1);
      await audioManagerQuestion.setVolume(1);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }

    try {
      await upsertResult(listen: false);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }

    isLoading = false;
    safeNotify();

    try {
      await audioManager.setUrl(phraseModel.recording ?? "");
      if (phraseModel.questionRecording != null &&
          phraseModel.questionRecording != '') {
        await audioManagerQuestion.setUrl(phraseModel.questionRecording ?? "");
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    if (phraseModel.questions != null) {
      await playQuestionAudio();
    } else {
      await playAudio(context);
    }
  }

  Future<void> playAudio(BuildContext context) async {
    try {
      final player = audioManager;

      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      if (!player.playing && !isRecordingNotifier.value) {
        await player.play();
        await upsertResult();
      }
    } catch (e) {
      rethrow;
    }

    if (context.mounted) notifyListeners();
  }

  Future<void> pauseAudio(BuildContext context) async {
    try {
      final player = audioManager;

      if (player.playing) {
        await player.pause();
      }
    } catch (e) {
      rethrow;
    }
    if (context.mounted) notifyListeners();
  }

  Future<void> togglePlayPause() async {
    try {
      final player = audioManager;

      if (player.playing) {
        await player.pause();
      } else {
        if (player.playerState.processingState == ProcessingState.completed) {
          await player.seek(Duration.zero);
        }
        if (!player.playing && !isRecordingNotifier.value) {
          await player.play();
          await upsertResult();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> playQuestionAudio() async {
    try {
      final player = audioManagerQuestion;

      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      if (!player.playing && !isRecordingNotifier.value) {
        await player.play();
        await upsertResult();
      }
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

  void toggleTranslation() {
    showMoreTranslation = !showMoreTranslation;
    safeNotify();
  }
}
