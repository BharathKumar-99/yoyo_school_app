import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/core/audio/global_recording_state.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/recording/presentation/recorder_provider.dart';

import 'audio_control_widget.dart';

class ReadAndPractiseScreen extends StatelessWidget {
  final PhraseModel model;
  final Language launguage;
  final int? streak;
  final bool isLast;
  final AudioPlayer audioManager;
  final AudioPlayer? audioManagerQuestion;
  const ReadAndPractiseScreen({
    super.key,
    required this.model,
    required this.launguage,
    this.streak,
    required this.isLast,
    required this.audioManager,
    this.audioManagerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingProvider>(
      builder: (context, value, wid) {
        return Container(
          color: Colors.transparent,
          height: MediaQuery.sizeOf(context).height / 4.99,
          width: double.infinity,
          child: Column(
            children: [
              AudioWaveforms(
                waveStyle: WaveStyle(
                  waveColor: Colors.black,
                  showDurationLabel: false,
                  spacing: 8.0,
                  showBottom: false,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
                size: Size(MediaQuery.sizeOf(context).width - 100, 30),
                recorderController: value.recorderController,
              ),
              AudioControlWidget(
                color: launguage.gradient?.first ?? Colors.white,
                bgColor: launguage.gradient?.first ?? Colors.white,
                isRecording: isRecordingNotifier.value,
                border: Colors.grey,
                onStartHold: () async {
                  if (audioManager.playing) {
                    await audioManager.stop();
                  }
                  if (audioManagerQuestion?.playing ?? false) {
                    await audioManagerQuestion?.stop();
                  }
                  value.toggleRecording(context);
                },
                onReleaseHold: () async {
                  if (audioManager.playing) {
                    await audioManager.stop();
                  }
                  if (audioManagerQuestion?.playing ?? false) {
                    await audioManagerQuestion?.stop();
                  }
                  value.toggleRecording(context);
                },

                onSwipeLeft: () => value.toggleRecording(context, cancel: true),
                onSwipeRight: () =>
                    value.toggleRecording(context, cancel: true),

                onLeftDeleteTap: () =>
                    value.toggleRecording(context, cancel: true),
                onRightDeleteTap: () =>
                    value.toggleRecording(context, cancel: true),
              ),
              Spacer(flex: 2),
              Text(
                (isRecordingNotifier.value) ? text.recording : text.learnIt,
                style: TextStyle(color: Colors.black),
              ),
              Spacer(flex: 1),
              Text(text.holdAndRecord, style: TextStyle(color: Colors.black)),
              Spacer(flex: 1),
              if (isRecordingNotifier.value)
                Text(
                  value.recordingTime,
                  style: TextStyle(color: Colors.black),
                ),
              Spacer(),
            ],
          ),
        );
      },
    );
  }
}
