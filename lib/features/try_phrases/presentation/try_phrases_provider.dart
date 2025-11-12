import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../../config/constants/constants.dart';
import '../../../config/utils/get_user_details.dart';
import '../../../config/utils/global_loader.dart';
import '../../recording/presentation/read_and_practise_screen.dart'
    show ReadAndPractiseScreen;
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
    language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
    await audioManager.setUrl(phraseModel.recording ?? "");
    result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    await audioManager.setVolume(1);
    await upsertResult(listen: false);
    isLoading = false;
    safeNotify();
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
    await playAudio();
  }

  void togglePhrase() {
    showPhrase = !showPhrase;
    safeNotify();
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
      debugPrint("playAudio error: $e");
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

  void showReadBottomPopup(BuildContext context) {
    showModalBottomSheet(
      elevation: 1,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ReadAndPractiseScreen(
        model: phraseModel,
        launguage: language!,
        streak: streak,
        isLast: isLast,
      ),
    );
  }
}
