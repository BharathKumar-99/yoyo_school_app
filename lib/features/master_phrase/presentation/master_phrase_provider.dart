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
  bool isLoading = true;
  bool showStreakVal = false;
  MasterPhraseProvider(this.phraseModel) {
    init();
  }

  init() async {
    isLoading = true;
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
    result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    await upsertResult(listen: false);
    isLoading = false;
    await audioManager.setUrl(phraseModel.recording ?? "");
    await audioManager.setVolume(1);
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  Future<void> upsertResult({bool listen = true}) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    result ??= UserResult(
      userId: userId,
      phrasesId: phraseModel.id,
      type: Constants.mastered,
    );

    result = await _repo.upsertResult(result!);
  }

  playAudio() async {
    try {
      final player = audioManager;
      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      await player.play();
      await upsertResult();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showStreak() {
    showStreakVal = true;
    notifyListeners();
  }
}
