import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/try_phrases/presentation/try_phrases_provider.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';

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
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Padding(
                    key: ValueKey(value.showPhrase),
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  value.language?.gradient?.first.withValues(
                                    alpha: 0.4,
                                  ) ??
                                  Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (value.language?.gradient?.first ??
                                            Colors.black)
                                        .withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28.0,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                AnimatedOpacity(
                                  opacity: value.showPhrase ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 400),
                                  child: AnimatedSlide(
                                    offset: value.showPhrase
                                        ? Offset.zero
                                        : const Offset(0, 0.2),
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    child: Text(
                                      value.phraseModel.phrase ?? "",
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      style:
                                          AppTextStyles.textTheme.headlineLarge,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AnimatedScale(
                                      scale: value.showPhrase ? 1.0 : 0.9,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: IconButton(
                                        onPressed: value.togglePhrase,
                                        icon: Icon(
                                          value.showPhrase
                                              ? Icons.visibility_rounded
                                              : Icons.visibility_off_rounded,
                                          size: 45,
                                          color: value.showPhrase
                                              ? value.language?.gradient?.first
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      splashColor:
                                          value.language?.gradient?.first
                                              .withValues(alpha: 0.2) ??
                                          Colors.grey.withValues(alpha: 0.2),
                                      onTap: () => value.playAudio(),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 600),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.translate_rounded),
                                ),
                                Expanded(
                                  child: Text(
                                    value.phraseModel.translation ?? '',
                                    style: AppTextStyles.textTheme.titleMedium
                                        ?.copyWith(height: 1.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  elevation: 6,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    "Try this phrase",
                    key: ValueKey(value.showPhrase),
                    style: AppTextStyles.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
