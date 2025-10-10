import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';

import 'remember_recorder_provider.dart';

class RememberAndPractiseScreen extends StatelessWidget {
  const RememberAndPractiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RememberRecorderProvider>(
      create: (context) => RememberRecorderProvider(),
      child: Consumer<RememberRecorderProvider>(
        builder: (context, value, wid) {
          return Container(
            height: MediaQuery.sizeOf(context).height / 3,
            decoration: BoxDecoration(
              color: Color(0xFFEF2E36),
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
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80 / 2,
                      child: IconButton(
                        onPressed: () => value.toggleRecording(),
                        icon: Icon(
                          value.isRecording
                              ? Icons.close_rounded
                              : Icons.mic_none_rounded,
                          size: 45,
                          color: Colors.black,
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
                  (value.isRecording)
                      ? text.recording
                      : text.rememberAndPractise,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 5),
                if (value.isRecording)
                  Text(
                    value.recordingTime,
                    style: TextStyle(color: Colors.black),
                  ),
                SizedBox(height: 5),
               
              ],
            ),
          );
        },
      ),
    );
  }
}
