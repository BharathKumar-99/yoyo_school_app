import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';

import '../../home/model/phrases_model.dart';
import '../data/listen_repo.dart';

class ListenAndTypeViewModel extends ChangeNotifier {
  final RecorderController waveController = RecorderController();
  bool isPlaying = true;
  PhraseModel phraseModel;
  TextEditingController textEditingController = TextEditingController();
  Language? language;
  final int categories;
  final AudioPlayer audioManager = AudioPlayer();
  final ListenRepo _repo = ListenRepo();
  ListenAndTypeViewModel(this.phraseModel, this.categories) {
    initAudio();
    getData();
    _listenToPlayerState();
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
    notifyListeners();
    await playAudio();
  }

  Future<void> playAudio() async {
    try {
      final player = audioManager;

      if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      isPlaying = true;
      notifyListeners();

      await player.play();
    } catch (e) {
      rethrow;
    }
  }

  submit() {
    ctx!.push(
      RouteNames.listenAndTypeScreenResult,
      extra: {
        'phraseModel': phraseModel,
        'typedPhrase': textEditingController.text.trim(),
        'language': language,
      },
    );
  }

  void _listenToPlayerState() {
    audioManager.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        isPlaying = false;
        notifyListeners();
      }
    });
  }
}
