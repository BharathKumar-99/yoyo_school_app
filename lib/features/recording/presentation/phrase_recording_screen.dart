import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/recording/presentation/phrase_recording_provider.dart';

class PhraseRecordingScreen extends StatelessWidget {
  final PhraseModel phrase;
  const PhraseRecordingScreen({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhraseRecordingProvider>(
      create: (_) => PhraseRecordingProvider(phrase),
      child: Consumer<PhraseRecordingProvider>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(leadingWidth: 80, leading: backBtn()),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFF6895B), width: 3),
                ),
                child: Column(
                  children: [
                    Text(
                      phrase.phrase ?? "",
                      style: AppTextStyles.textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
