import 'dart:async';
import 'dart:developer';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RememberRecorderProvider extends ChangeNotifier {
  late final RecorderController recorderController;
  final player = AudioPlayer();
  bool isRecording = false;
  String? recordingPath;
  String recordingTime = "00:00";
  late final StreamSubscription<Duration> _durationSubscription;
  RememberRecorderProvider() {
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
          await player.setVolume(1);
          await player.play();
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
