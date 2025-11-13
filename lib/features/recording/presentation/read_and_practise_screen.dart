import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/recording/presentation/recorder_provider.dart';

class ReadAndPractiseScreen extends StatelessWidget {
  final PhraseModel model;
  final Language launguage;
  final int? streak;
  final bool isLast;
  const ReadAndPractiseScreen({
    super.key,
    required this.model,
    required this.launguage,
    this.streak,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingProvider>(
      builder: (context, value, wid) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height / 3,
          width: double.infinity,
          child: Column(
            children: [
              Spacer(),
              Row(
                children: [
                  Spacer(),
                  if (value.isRecording)
                    AudioWaveforms(
                      waveStyle: WaveStyle(
                        waveColor: Colors.black,
                        showDurationLabel: false,
                        spacing: 8.0,
                        showBottom: false,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      size: Size(50, 50.0),
                      recorderController: value.recorderController,
                    ),
                  Spacer(),
                  Listener(
                    onPointerDown: (_) => value.toggleRecording(context),
                    onPointerUp: (_) => value.toggleRecording(context),
                    onPointerCancel: (_) => value.toggleRecording(context),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor:
                          launguage.gradient?.first ?? Colors.white,
                      child: CircleAvatar(
                        backgroundColor: value.isRecording
                            ? launguage.gradient?.first ?? Colors.white
                            : Colors.white,
                        radius: 40,
                        child: Icon(
                          value.isRecording
                              ? Icons.mic
                              : Icons.mic_none_rounded,
                          size: 45,
                          color: value.isRecording
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  Spacer(),
                  if (value.isRecording)
                    AudioWaveforms(
                      waveStyle: WaveStyle(
                        waveColor: Colors.black,
                        showDurationLabel: false,
                        spacing: 8.0,
                        showBottom: false,
                        extendWaveform: true,
                        showMiddleLine: false,
                      ),
                      size: Size(50, 50.0),
                      recorderController: value.recorderController,
                    ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20),
              Text(
                (value.isRecording) ? text.recording : text.learnIt,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 5),
              Text(text.holdAndRecord, style: TextStyle(color: Colors.black)),
              SizedBox(height: 5),
              if (value.isRecording)
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
