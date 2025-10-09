import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Color(0xFFF6895B), width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      children: [
                        Text(
                          value.showPhrase
                              ? value.phraseModel.phrase ?? ""
                              : '',
                          maxLines: 3,
                          style: AppTextStyles.textTheme.headlineLarge,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                value.togglePhrase();
                              },
                              icon: Icon(
                                value.showPhrase
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: 50,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.play_arrow_outlined, size: 50),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.translate_rounded),
                      ),
                      Expanded(
                        child: Text(value.phraseModel.translation ?? ''),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF6865A),
                    ),
                    child: Text(
                      text.readAndpractise,
                      style: AppTextStyles.textTheme.titleMedium,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => value.showReadBottomPopup(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF2E36),
                    ),
                    child: Text(
                      text.rememberAndPractise,
                      style: AppTextStyles.textTheme.titleMedium ,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
