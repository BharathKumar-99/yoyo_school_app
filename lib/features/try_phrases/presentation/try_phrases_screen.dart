import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart'
    show AppTextStyles;
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/try_phrases/presentation/try_phrases_provider.dart';

import '../../../core/widgets/back_btn.dart';

class TryPhrasesScreen extends StatelessWidget {
  final PhraseModel phraseModel;
  const TryPhrasesScreen({super.key, required this.phraseModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TryPhrasesProvider>(
      create: (_) => TryPhrasesProvider(phraseModel),
      child: Consumer<TryPhrasesProvider>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(leadingWidth: 80, leading: backBtn()),
          body: value.isLoading
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color:
                                value.language?.gradient?.first.withValues(
                                  alpha: 0.4,
                                ) ??
                                Colors.white,
                            width: 3,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28.0,
                            vertical: 20,
                          ),
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
                                    onPressed: () => value.playAudio(),
                                    icon: Icon(
                                      Icons.play_arrow_outlined,
                                      size: 50,
                                    ),
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
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => value.showReadBottomPopup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      value.language?.gradient?.first ?? Colors.white,
                ),
                child: Text(
                  text.tryThisPhrase,
                  style: AppTextStyles.textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
