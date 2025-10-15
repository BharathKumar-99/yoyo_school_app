import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/recording/data/phrase_repo.dart';
import 'package:yoyo_school_app/features/recording/presentation/read_and_practise_screen.dart';
import 'package:yoyo_school_app/features/recording/presentation/remember_and_practise_screen.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

class PhraseRecordingProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  bool showPhrase = true;
  Language? language;
  final PhraseRepo _repo = PhraseRepo();
  final player = AudioPlayer();
  late UserResult? result;
  bool isLoading = true;

  PhraseRecordingProvider(this.phraseModel) {
    initAudio();
  }

  initAudio() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
    await player.setUrl(phraseModel.recording ?? "");
    result = await _repo.getAttemptedPhrase(phraseModel.id ?? 0);
    await player.setVolume(1);
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
      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      await player.play();
      await upsertResult();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> upsertResult() async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    result ??= UserResult(userId: userId, phrasesId: phraseModel.id);
    result?.listen = (result?.listen ?? 0) + 1;
    result = await _repo.upsertResult(result!);
  }

  showReadBottomPopup(BuildContext context) => showModalBottomSheet(
    elevation: 1,
    context: context,
    builder: (_) =>
        ReadAndPractiseScreen(model: phraseModel, launguage: language!),
  );

  showRememberBottomPopup(BuildContext context) => showModalBottomSheet(
    elevation: 1,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: language?.gradient ?? [],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: NetworkImage(language?.image ?? ""),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 30),
            child: Align(alignment: Alignment.topLeft, child: backBtn()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.translate_rounded),
                ),
                Expanded(child: Text(phraseModel.translation ?? '')),
              ],
            ),
          ),
          Spacer(),
          RememberAndPractiseScreen(model: phraseModel, launguage: language!),
        ],
      ),
    ),
  );
}
