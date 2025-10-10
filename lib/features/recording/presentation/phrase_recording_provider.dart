import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/recording/presentation/read_and_practise_screen.dart';
import 'package:yoyo_school_app/features/recording/presentation/remember_and_practise_screen.dart';

class PhraseRecordingProvider extends ChangeNotifier {
  PhraseModel phraseModel;
  bool showPhrase = true;
  final player = AudioPlayer();

  PhraseRecordingProvider(this.phraseModel) {
    initAudio();
  }

  initAudio() async {
    await player.setUrl(phraseModel.recording ?? "");
    await player.setVolume(1);
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  showReadBottomPopup(BuildContext context) => showModalBottomSheet(
    elevation: 1,
    context: context,
    builder: (_) => ReadAndPractiseScreen(),
  );

  showRememberBottomPopup(BuildContext context) => showModalBottomSheet(
    elevation: 1,
    context: context,
    builder: (_) => RememberAndPractiseScreen(),
  );
}
