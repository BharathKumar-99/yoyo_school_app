import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/utils/audio_manager_singleton.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../../config/constants/constants.dart';
import '../../recording/presentation/read_and_practise_screen.dart';
import '../data/try_phrases_repo.dart';

class TryPhrasesProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  bool showPhrase = true;
  Language? language;
  final TryPhrasesRepo _repo = TryPhrasesRepo();
  final AudioManager audioManager = AudioManager();
  late UserResult? result;
  bool isLoading = true;

  TryPhrasesProvider(this.phraseModel) {
    initAudio();
  }

  initAudio() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
    await audioManager.player.setUrl(phraseModel.recording ?? "");
    result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    await audioManager.setVolume(1);
    await upsertResult(listen: false);
    isLoading = false;
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  togglePhrase() {
    showPhrase = !showPhrase;
    notifyListeners();
  }

  playAudio() async {
    try {
      final player = audioManager.player;
      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      await player.play();
      await upsertResult();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> upsertResult({bool listen = true}) async {
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
  }

  showReadBottomPopup(BuildContext context) => showModalBottomSheet(
    elevation: 1,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        ReadAndPractiseScreen(model: phraseModel, launguage: language!),
  );
}
