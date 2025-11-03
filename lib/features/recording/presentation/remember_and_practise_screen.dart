import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';

import 'remember_recorder_provider.dart';

class RememberAndPractiseScreen extends StatelessWidget {
  final PhraseModel model;
  final Language launguage;
  const RememberAndPractiseScreen({
    super.key,
    required this.model,
    required this.launguage,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RememberRecorderProvider>(
      create: (context) => RememberRecorderProvider(model, launguage),
      child: Consumer<RememberRecorderProvider>(
        builder: (context, value, wid) {
          return Container(
            height: MediaQuery.sizeOf(context).height / 3,
            decoration: BoxDecoration(
              color: launguage.gradient?.first ?? Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
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
                    Spacer(),
                    Listener(
                      onPointerDown: (_) => value.toggleRecording(),
                      onPointerUp: (_) => value.toggleRecording(),
                      onPointerCancel: (_) => value.toggleRecording(),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: Icon(
                          value.isRecording
                              ? Icons.mic
                              : Icons.mic_none_rounded,
                          size: 45,
                          color: value.isRecording ? Colors.red : Colors.black,
                        ),
                      ),
                    ),

                    Spacer(),
                    if (value.isRecording)
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
                    Spacer(),
                  ],
                ),

                SizedBox(height: 20),
                Text(
                  (value.isRecording) ? text.recording : text.tryToMaster,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 5),
                if (value.isRecording)
                  Text(
                    value.recordingTime,
                    style: TextStyle(color: Colors.black),
                  ),
                SizedBox(height: 5),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
