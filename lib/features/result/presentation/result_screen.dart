import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/presentation/result_provider.dart';

class ResultScreen extends StatelessWidget {
  final PhraseModel phraseModel;
  final Language language;
  final String audioPath;
  final bool isLast;
  final int retryNumber;
  final int categories;
  const ResultScreen({
    super.key,
    required this.phraseModel,
    required this.audioPath,
    required this.language,
    required this.isLast,
    required this.retryNumber,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    double h(double factor) => height * factor;
    double w(double factor) => width * factor;

    return ChangeNotifierProvider<ResultProvider>(
      create: (_) => ResultProvider(phraseModel, audioPath, language),
      child: Consumer<ResultProvider>(
        builder: (context, value, child) => Scaffold(
          body: value.speechEvaluationModel == null
              ? Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    color: language.gradient?.first ?? Colors.white,
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 200,
                      child: Lottie.asset(
                        AnimationAsset.yoyoWaitingText,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : value.score <= Constants.lowScreenScore
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 26, right: 26),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(),
                        Text(
                          text.whoops,
                          style: AppTextStyles.textTheme.headlineLarge,
                        ),
                        Text(
                          text.itseemslikesomethingwentwrong,
                          style: AppTextStyles.textTheme.bodyMedium,
                        ),
                        Image.asset(ImageConstants.noMic),
                        Text(
                          text.check,
                          style: AppTextStyles.textTheme.titleLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            spacing: 10,
                            children: [
                              Row(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(text.checkMark),
                                  Expanded(
                                    child: Text(
                                      text.noBgNoise,
                                      style: AppTextStyles.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(text.checkMark),
                                  Expanded(
                                    child: Text(
                                      text.holdingRec,
                                      style: AppTextStyles.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 6,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(text.checkMark),
                                  Expanded(
                                    child: Text(
                                      text.micPermission,
                                      style: AppTextStyles.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        retryNumber >= Constants.retryAttempts
                            ? Column(
                                spacing: 5,
                                children: [
                                  Text(
                                    text.threeTryNext,
                                    style: AppTextStyles.textTheme.bodyMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => context.go(
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
                                          'categories': categories,
                                        },
                                      ),

                                      child: Text(text.next_phrase),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => context.pop(retryNumber + 1),
                                  child: Text(text.tryAgain),
                                ),
                              ),
                        Spacer(),
                      ],
                    ),
                  ),
                )
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
                                    child: IconButton(
                                      onPressed: () async {
                                        NavigationHelper.pop();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              Colors.transparent,
                                            ),
                                        shape: WidgetStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        fixedSize: WidgetStateProperty.all(
                                          const Size(40, 40),
                                        ),
                                      ),
                                    ),
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
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12.0,
                                                        ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                              sigmaX: 10,
                                                              sigmaY: 10,
                                                            ),
                                                        child: Container(
                                                          color: Colors.black
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                                vertical: 6,
                                                              ),
                                                          child: Text(
                                                            "${text.youareJust} ${Constants.minimumSubmitScore - value.score}% ${text.off}",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: AppTextStyles
                                                                .textTheme
                                                                .headlineMedium!
                                                                .copyWith(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )
                                        : SizedBox(
                                            width: w(0.40),
                                            height: h(0.18),

                                            child: Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 10,
                                                    sigmaY: 10,
                                                  ),
                                                  child: Container(
                                                    color: Colors.black
                                                        .withValues(alpha: 0.1),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
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
                                        value.tableResponse?.title ?? "",
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 20.0,
                                        ),
                                        child: Text(
                                          value.tableResponse?.body ?? '',
                                          style: AppTextStyles
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.black),
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
                                                            .gptResponse
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
                                      retryNumber >= Constants.retryAttempts
                                          ? SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () => context.go(
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
                                                    'categories': categories,
                                                  },
                                                ),

                                                child: Text(text.next_phrase),
                                              ),
                                            )
                                          : SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () => context.pop(
                                                  retryNumber + 1,
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
                                      Spacer(flex: 3),
                                      Text(
                                        value.tableResponse?.title ?? '',
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
                                      Text(value.tableResponse?.body ?? ''),
                                      Spacer(),
                                      isLast
                                          ? SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                text.lastLearned,
                                                textAlign: TextAlign.center,
                                                style: AppTextStyles
                                                    .textTheme
                                                    .titleSmall,
                                              ),
                                            )
                                          : (value
                                                    .globalProvider
                                                    .apiCred
                                                    .streak ==
                                                true)
                                          ? SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () => context.go(
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
                                                    'from': 'new',
                                                    "streak": 1,
                                                    'categories': categories,
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
                                            )
                                          : value.globalProvider.apiCred.mastery
                                          ? SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () => context.go(
                                                  RouteNames.masterPhrases,
                                                  extra: {
                                                    'student': value.userClases,
                                                    "phrase": value.phraseModel,
                                                    "streak": null,
                                                    "language": value.language,
                                                    "schoolLanguage":
                                                        value.slanguage,
                                                    "className":
                                                        value
                                                            .userClases
                                                            ?.classes
                                                            ?.className ??
                                                        "",
                                                    'categories': categories,
                                                    "isLast": false,
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
                                                  text.tryToMaster,
                                                  style: AppTextStyles
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () => context.go(
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
                                                    "next": true,
                                                    "from": "new",
                                                    'categories': categories,
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
                                                  text.next_phrase,
                                                  style: AppTextStyles
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                            ),

                                      SizedBox(height: 5),
                                      Center(
                                        child: TextButton(
                                          onPressed: () {
                                            context.go(RouteNames.home);
                                          },
                                          child: Text(
                                            'Back to dashboard',
                                            style: AppTextStyles
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black,
                                                ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    if (value.score > Constants.minimumSubmitScore)
                      Column(
                        children: [
                          Spacer(flex: 4),
                          Lottie.asset(
                            AnimationAsset.learnedSuccess,
                            fit: BoxFit.cover,
                            repeat: false,
                          ),
                          Spacer(flex: 5),
                        ],
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
