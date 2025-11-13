import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/school_launguage.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/try_phrases/presentation/try_phrases_provider.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';

import '../../../config/router/navigation_helper.dart';
import '../../recording/presentation/read_and_practise_screen.dart';

class TryPhrasesScreen extends StatelessWidget {
  final PhraseModel phraseModel;
  final int? streak;
  final SchoolLanguage schoolLanguage;
  final String className;
  final Student student;
  final bool isLast;
  const TryPhrasesScreen({
    super.key,
    required this.phraseModel,
    this.streak,
    required this.schoolLanguage,
    required this.className,
    required this.student,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TryPhrasesProvider>(
      builder: (context, value, child) => Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leadingWidth: 80,
              leading: backBtn(
                streak: streak != null,
                context: context,
                slanguage: schoolLanguage,
                className: className,
                student: student,
              ),
            ),
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
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeOut,
                                      child: Text(
                                        value.phraseModel.phrase ?? "",
                                        maxLines: 3,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineLarge,
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
                                                ? value
                                                      .language
                                                      ?.gradient
                                                      ?.first
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
                                        onTap: () async =>
                                            await value.playAudio(),
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
                          if (streak != null && value.showStreakVal)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    text.streak,
                                    style: AppTextStyles.textTheme.bodyLarge
                                        ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                          fontFamily: 'Sansita',
                                        ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "X$streak ",
                                        style: AppTextStyles.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                              fontFamily: 'Sansita',
                                            ),
                                      ),
                                      Image.asset(
                                        ImageConstants.streak,
                                        height: 50,
                                        width: 50,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: value.language != null
                ? ReadAndPractiseScreen(
                    model: phraseModel,
                    launguage: value.language!,
                    streak: streak,
                    isLast: isLast,
                  )
                : Container(),
          ),
          if (streak != null && !value.isLoading)
            Lottie.asset(
              AnimationAsset.streakAnimation,
              repeat: false,
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width * 2,
              height: MediaQuery.sizeOf(context).height * 2,
              onLoaded: (composition) {
                Future.delayed(
                  Duration(seconds: composition.duration.inSeconds - 2),
                  () {
                    value.showStreak();
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
