import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';

import '../../home/model/phrases_model.dart';
import '../data/listen_repo.dart';

class ListenAndTypeViewModel extends ChangeNotifier {
  PhraseModel phraseModel;
  Language? language;
  final int categories;
  final AudioPlayer audioManager = AudioPlayer();
  final ListenRepo _repo = ListenRepo();
  ListenAndTypeViewModel(this.phraseModel, this.categories) {
    initAudio();
    getData();
  }

  getData() async {
    language = await _repo.getPhraseModelData(phraseModel.language ?? 0);
  }

  Future<void> initAudio() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());

    try {
      await audioManager.setVolume(1);
      await audioManager.setUrl(phraseModel.recording ?? "");
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
      rethrow;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  Future<void> playAudio() async {
    try {
      final player = audioManager;

      if (player.playerState.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      await player.play();
    } catch (e) {
      rethrow;
    }
  }
}
