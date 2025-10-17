import 'dart:async';
import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';

class RememberRecorderProvider extends ChangeNotifier {
  late final RecorderController recorderController;
  PhraseModel phraseModel;
  final player = AudioPlayer();
  Language language;
  bool isRecording = false;
  String? recordingPath;
  String recordingTime = "00:00";
  late final StreamSubscription<Duration> _durationSubscription;
  RememberRecorderProvider(this.phraseModel, this.language) {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    _durationSubscription = recorderController.onCurrentDuration.listen((
      duration,
    ) {
      final minutes = duration.inMinutes
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      final seconds = duration.inSeconds
          .remainder(60)
          .toString()
          .padLeft(2, '0');
      recordingTime = "$minutes:$seconds";
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _durationSubscription.cancel();
    recorderController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> toggleRecording() async {
    try {
      if (isRecording) {
        recordingPath = await recorderController.stop();
        isRecording = false;
        if (recordingPath != null) {
          recordingTime = "00:00";
          await player.setFilePath(recordingPath!);
          NavigationHelper.push(
            RouteNames.masterResult,
            extra: {
              'phraseModel': phraseModel,
              'path': recordingPath,
              'language': language,
            },
          );
        }
        notifyListeners();
      } else {
        await recorderController.record();
        isRecording = true;
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
