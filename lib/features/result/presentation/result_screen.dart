import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/presentation/result_provider.dart';

class ResultScreen extends StatelessWidget {
  final PhraseModel phraseModel;
  final Language language;
  final int? streak;

  final String audioPath;
  const ResultScreen({
    super.key,
    required this.phraseModel,
    required this.audioPath,
    required this.language,
    this.streak,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    double h(double factor) => height * factor;
    double w(double factor) => width * factor;

    return ChangeNotifierProvider<ResultProvider>(
      create: (_) => ResultProvider(phraseModel, audioPath, language, streak),
      child: Consumer<ResultProvider>(
        builder: (context, value, child) => Scaffold(
          body: value.speechEvaluationModel == null
              ? Container()
              : Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: h(0.5),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: language.gradient ?? [],
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                value.language.image ?? '',
                              ),
                              fit: BoxFit.fill,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(70),
                                spreadRadius: 5,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w(0.07),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: backBtn(),
                                  ),
                                  Spacer(),

                                  SizedBox(
                                    width: double.infinity,
                                    child:
                                        (value.score <
                                            Constants.minimumSubmitScore)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Card(
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                    w(0.04),
                                                  ),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        Wrap(
                                                          spacing: w(0.013),
                                                          children: value
                                                              .speechEvaluationModel!
                                                              .result!
                                                              .words!
                                                              .map(
                                                                (word) => Text(
                                                                  word.word ??
                                                                      "",
                                                                  style: AppTextStyles
                                                                      .textTheme
                                                                      .titleLarge!
                                                                      .copyWith(
                                                                        fontSize: w(
                                                                          0.06,
                                                                        ),
                                                                        color: value.getWordColor(
                                                                          word.scores?.overall ??
                                                                              0,
                                                                        ),
                                                                      ),
                                                                ),
                                                              )
                                                              .toList(),
                                                        ),
                                                        SizedBox(
                                                          height: h(0.04),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if ((Constants.minimumSubmitScore -
                                                          value.score <
                                                      10) &&
                                                  Constants.minimumSubmitScore -
                                                          value.score >
                                                      0)
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    12.0,
                                                  ),
                                                  child: Text(
                                                    "${text.youareJust} ${Constants.minimumSubmitScore - value.score}% ${text.off}",
                                                    style: AppTextStyles
                                                        .textTheme
                                                        .headlineMedium!
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                            ],
                                          )
                                        : SizedBox(
                                            width: w(0.40),
                                            height: h(0.18),

                                            child: Center(
                                              child: Text(
                                                '${value.score.toString()} %',
                                                style: AppTextStyles
                                                    .textTheme
                                                    .headlineLarge!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: w(0.12),
                                                    ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: w(0.07)),
                            child: (value.score < Constants.minimumSubmitScore)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: h(0.01)),
                                      Text(
                                        value.resultText?.title ?? "",
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            text: value.resultText?.feedback,
                                            style: AppTextStyles
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: Colors.black),
                                            children: [
                                              if (value
                                                      .result
                                                      ?.badWords
                                                      ?.isNotEmpty ??
                                                  false)
                                                TextSpan(
                                                  text:
                                                      ' ${text.especially_in} ${value.result?.badWords?.map((val) => val)}'
                                                          .replaceAll('(', '')
                                                          .replaceAll(')', ''),
                                                  style: AppTextStyles
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Text(
                                                '👉🏻',
                                                style: AppTextStyles
                                                    .textTheme
                                                    .headlineLarge,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Colors.grey.shade300,
                                                ),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text:
                                                        ' ${text.repeat_slowly} ${value.result?.badWords?.map((val) => val)} '
                                                            .replaceAll('(', '')
                                                            .replaceAll(
                                                              ')',
                                                              '',
                                                            ),
                                                    style: AppTextStyles
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),

                                                    children: [
                                                      TextSpan(
                                                        text: value
                                                            .resultText
                                                            ?.microDrill,
                                                        style: AppTextStyles
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              context.pushReplacement(
                                                RouteNames.tryPhrases,
                                                extra: {
                                                  "streak": streak,
                                                  "phrase": phraseModel,
                                                },
                                              ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                value
                                                    .language
                                                    .gradient
                                                    ?.first ??
                                                Colors.blue,
                                          ),
                                          child: Text(
                                            text.tryAgain,
                                            style: AppTextStyles
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Spacer(flex: 2),
                                      Text(
                                        text.congratulations,
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineLarge,
                                      ),

                                      Text(
                                        text.you_did_it,
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      Spacer(),
                                      Text(
                                        "${text.withAScoreOf} ${value.score.toString()}% ${text.youRocked}",
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              context.pushReplacement(
                                                RouteNames.phrasesDetails,
                                                extra: {
                                                  'language': value.slanguage,
                                                  "className":
                                                      value
                                                          .userClases
                                                          ?.classes
                                                          ?.className ??
                                                      "",
                                                  "level": value.levels ?? [],
                                                  'student': value.userClases,
                                                  'next': true,
                                                  "streak": (streak ?? 0) + 1,
                                                },
                                              ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                value
                                                    .language
                                                    .gradient
                                                    ?.first ??
                                                Colors.blue,
                                          ),
                                          child: Text(
                                            text.goOnAStreak,
                                            style: AppTextStyles
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    if (value.score > Constants.minimumSubmitScore)
                      Column(
                        children: [
                          Spacer(),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height / 5,
                            width: double.infinity,
                            child: RiveAnimation.asset(
                              'assets/animation/confetti.riv',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
