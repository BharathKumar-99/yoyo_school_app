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
import 'package:auto_size_text/auto_size_text.dart';
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
                categories: value.categories,
              ),
            ),
            body: value.isLoading
                ? Container()
                : SafeArea(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Padding(
                        key: ValueKey(value.showPhrase),
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  if (phraseModel.questions != null)
                                    Column(
                                      spacing: 5,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),

                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    (value
                                                                .language
                                                                ?.gradient
                                                                ?.first ??
                                                            Colors.black)
                                                        .withValues(alpha: 0.1),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                            color: Colors.grey.shade300,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 28.0,
                                              vertical: 20,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    ((value
                                                                    .phraseModel
                                                                    .questions
                                                                    ?.length ??
                                                                0) >
                                                            100)
                                                        ? value
                                                                  .phraseModel
                                                                  .questions
                                                                  ?.substring(
                                                                    0,
                                                                    100,
                                                                  ) ??
                                                              ''
                                                        : value
                                                                  .phraseModel
                                                                  .questions ??
                                                              '',
                                                    maxLines: 3,
                                                    textAlign: TextAlign.left,
                                                    style: AppTextStyles
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                    splashColor:
                                                        value
                                                            .language
                                                            ?.gradient
                                                            ?.first
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ) ??
                                                        Colors.grey.withValues(
                                                          alpha: 0.2,
                                                        ),
                                                    onTap: () async =>
                                                        await value
                                                            .playQuestionAudio(),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .play_arrow_outlined,
                                                        size: 50,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        AnimatedSize(
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                          alignment: Alignment.topCenter,
                                          curve: Curves.decelerate,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                LayoutBuilder(
                                                  builder: (context, constraints) {
                                                    final String
                                                    translationText =
                                                        value
                                                            .phraseModel
                                                            .questionTranslation ??
                                                        '';

                                                    final TextStyle
                                                    style = AppTextStyles
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        );

                                                    final textPainter =
                                                        TextPainter(
                                                          text: TextSpan(
                                                            text:
                                                                translationText,
                                                            style: style,
                                                          ),
                                                          maxLines: 1,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                        )..layout(
                                                          maxWidth: constraints
                                                              .maxWidth,
                                                        );

                                                    final bool isMultiLine =
                                                        textPainter
                                                            .didExceedMaxLines;

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Icon(
                                                                Icons
                                                                    .translate_rounded,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                translationText,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: style,
                                                              ),
                                                            ),

                                                            if (isMultiLine)
                                                              Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child: GestureDetector(
                                                                  onTap: () => showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (_) =>
                                                                        AlertDialog(
                                                                          content: Text(
                                                                            translationText,
                                                                          ),
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    'Show More',
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 600,
                                      ),
                                      padding: EdgeInsets.only(top: 10),
                                      curve: Curves.easeInOut,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color:
                                              value.language?.gradient?.first
                                                  .withValues(alpha: 0.4) ??
                                              Colors.white,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (value
                                                            .language
                                                            ?.gradient
                                                            ?.first ??
                                                        Colors.black)
                                                    .withValues(alpha: 0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,

                                        spacing: 5,
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 28,
                                                right: 28,
                                              ),
                                              child: AnimatedOpacity(
                                                opacity: value.showPhrase
                                                    ? 1.0
                                                    : 0.0,
                                                duration: const Duration(
                                                  milliseconds: 400,
                                                ),
                                                child: AnimatedSlide(
                                                  offset: value.showPhrase
                                                      ? Offset.zero
                                                      : const Offset(0, 0.2),
                                                  duration: const Duration(
                                                    milliseconds: 400,
                                                  ),
                                                  curve: Curves.easeOut,
                                                  child: AutoSizeText(
                                                    (value
                                                                    .phraseModel
                                                                    .phrase
                                                                    ?.length ??
                                                                0) >
                                                            400
                                                        ? value
                                                                  .phraseModel
                                                                  .phrase
                                                                  ?.substring(
                                                                    0,
                                                                    100,
                                                                  ) ??
                                                              ''
                                                        : value
                                                                  .phraseModel
                                                                  .phrase ??
                                                              '',
                                                    textAlign: TextAlign.left,
                                                    minFontSize: 10,
                                                    maxFontSize:
                                                        AppTextStyles
                                                            .textTheme
                                                            .headlineLarge!
                                                            .fontSize ??
                                                        30,
                                                    style: AppTextStyles
                                                        .textTheme
                                                        .headlineLarge,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                              left: 28,
                                              right: 28,
                                            ),

                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              spacing: 10,
                                              children: [
                                                if (!(value
                                                        .phraseModel
                                                        .readingPhrase ??
                                                    true))
                                                  SizedBox(
                                                    height: 40,
                                                    width: 40,
                                                    child: AnimatedScale(
                                                      scale: value.showPhrase
                                                          ? 1.0
                                                          : 0.9,
                                                      duration: Duration(
                                                        milliseconds: 200,
                                                      ),
                                                      child: IconButton(
                                                        onPressed:
                                                            value.togglePhrase,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                        icon: Icon(
                                                          value.showPhrase
                                                              ? Icons
                                                                    .visibility_rounded
                                                              : Icons
                                                                    .visibility_off_rounded,
                                                          size: 45,
                                                          color:
                                                              value.showPhrase
                                                              ? value
                                                                    .language
                                                                    ?.gradient
                                                                    ?.first
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                SizedBox(
                                                  height: 40,
                                                  width: 40,
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          50,
                                                        ),
                                                    splashColor:
                                                        value
                                                            .language
                                                            ?.gradient
                                                            ?.first
                                                            .withValues(
                                                              alpha: 0.2,
                                                            ) ??
                                                        Colors.grey.withValues(
                                                          alpha: 0.2,
                                                        ),
                                                    onTap: () async =>
                                                        await value.playAudio(),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .play_arrow_outlined,
                                                        size: 45,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 600),
                                    alignment: Alignment.topCenter,
                                    curve: Curves.decelerate,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10),

                                          LayoutBuilder(
                                            builder: (context, constraints) {
                                              final String translationText =
                                                  value
                                                      .phraseModel
                                                      .translation ??
                                                  '';
                                              final TextStyle style =
                                                  AppTextStyles
                                                      .textTheme
                                                      .bodyMedium!;
                                              final textPainter =
                                                  TextPainter(
                                                    text: TextSpan(
                                                      text: translationText,
                                                      style: style,
                                                    ),
                                                    maxLines: 1,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                  )..layout(
                                                    maxWidth:
                                                        constraints.maxWidth,
                                                  );

                                              final bool isMultiLine =
                                                  textPainter.didExceedMaxLines;

                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    spacing: 5,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                        child: Icon(
                                                          Icons
                                                              .translate_rounded,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          value
                                                                  .phraseModel
                                                                  .translation ??
                                                              '',

                                                          maxLines: 1,
                                                          minFontSize: 15,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: AppTextStyles
                                                              .textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                height: 1.5,
                                                              ),
                                                        ),
                                                      ),
                                                      if (isMultiLine)
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: GestureDetector(
                                                            onTap: () => showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  AlertDialog(
                                                                    content: Text(
                                                                      value.phraseModel.translation ??
                                                                          '',
                                                                    ),
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              value.showMoreTranslation
                                                                  ? text.showLess
                                                                  : text.showMore,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (streak != null && value.showStreakVal)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "X$streak ",
                                                style: AppTextStyles
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                            value.language != null
                                ? ReadAndPractiseScreen(
                                    model: phraseModel,
                                    launguage: value.language!,
                                    streak: streak,
                                    isLast: isLast,
                                    audioManager: value.audioManager,
                                    audioManagerQuestion:
                                        value.audioManagerQuestion,
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          if (streak != null && !value.isLoading)
            IgnorePointer(
              ignoring: true,
              child: Lottie.asset(
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
            ),
        ],
      ),
    );
  }
}
