import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';

import '../../home/model/phrases_model.dart';
import '../../streak_recording/presentation/streak_recording_popup.dart';

class RecordingProvider extends ChangeNotifier {
  late final RecorderController recorderController;
  PhraseModel phraseModel;
  Language launguage;
  int? streak;
  final player = AudioPlayer();
  bool isRecording = false;
  String? recordingPath;
  String recordingTime = "00:00";
  late final StreamSubscription<Duration> _durationSubscription;
  bool isLast;
  int retryNumber = 1;
  int categories;

  RecordingProvider(
    this.phraseModel,
    this.launguage,
    this.streak,
    this.isLast,
    this.categories,
  ) {
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

  Future<void> toggleRecording(BuildContext ct, {bool cancel = false}) async {
    try {
      if (isRecording) {
        recordingPath = await recorderController.stop();
        isRecording = false;
        if (recordingPath != null && !cancel) {
          recordingTime = "00:00";
          await player.setFilePath(recordingPath!);
          if (streak != null) {
            showModalBottomSheet(
              elevation: 1,
              context: ct,
              isDismissible: false,
              backgroundColor: Colors.transparent,
              builder: (_) => StreakRecordingPopup(
                phraseModel: phraseModel,
                launguage: launguage,
                streak: streak!,
                audioPath: recordingPath!,
                form: "new",
                isLast: isLast,
                categories: categories,
              ),
            );
          } else {
            ctx!
                .push(
                  RouteNames.result,
                  extra: {
                    'phraseModel': phraseModel,
                    'path': recordingPath,
                    'language': launguage,
                    'isLast': isLast,
                    'retry': retryNumber,
                    'categories': categories,
                  },
                )
                .then((val) {
                  retryNumber = val is int ? val : 0;
                });
          }
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
