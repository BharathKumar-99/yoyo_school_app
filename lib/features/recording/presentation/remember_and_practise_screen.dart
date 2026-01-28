import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/core/audio/global_recording_state.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';

import 'audio_control_widget.dart';
import 'remember_recorder_provider.dart';

class RememberAndPractiseScreen extends StatelessWidget {
  final PhraseModel model;
  final Language launguage;
  final int? streak;
  final bool isLast;
  final AudioPlayer audioManager;
  final AudioPlayer? audioManagerQuestion;
  const RememberAndPractiseScreen({
    super.key,
    required this.model,
    required this.launguage,
    required this.streak,
    required this.isLast,
    required this.audioManager,
    this.audioManagerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RememberRecorderProvider>(
      builder: (context, value, wid) {
        return Container(
          height: MediaQuery.sizeOf(context).height / 3.6,
          decoration: BoxDecoration(
            color: launguage.gradient?.first ?? Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: double.infinity,
          child: Column(
            children: [
              Spacer(),
              AudioWaveforms(
                waveStyle: WaveStyle(
                  waveColor: Colors.white,
                  showDurationLabel: false,
                  spacing: 8.0,
                  showBottom: false,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
                size: Size(50, 50.0),
                recorderController: value.recorderController,
              ),
              AudioControlWidget(
                color: launguage.gradient?.first ?? Colors.white,
                isRecording: isRecordingNotifier.value,
                border: Colors.white,
                bgColor: Colors.white,
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
              SizedBox(height: 20),
              Text(
                (isRecordingNotifier.value) ? text.recording : text.masterIt,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(text.holdAndRecord, style: TextStyle(color: Colors.white)),
              SizedBox(height: 5),
              if (isRecordingNotifier.value)
                Text(
                  value.recordingTime,
                  style: TextStyle(color: Colors.white),
                ),
              SizedBox(height: 5),
              Spacer(),
            ],
          ),
        );
      },
    );
  }
}
