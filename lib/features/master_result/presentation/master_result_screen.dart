import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient, Image;
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/master_result/presentation/master_result_provider.dart';

class MasterResultScreen extends StatelessWidget {
  final PhraseModel phraseModel;
  final Language language;
  final String audioPath;
  const MasterResultScreen({
    super.key,
    required this.phraseModel,
    required this.audioPath,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    double h(double factor) => height * factor;
    double w(double factor) => width * factor;

    return ChangeNotifierProvider<MasterResultProvider>(
      create: (_) => MasterResultProvider(phraseModel, audioPath, language),
      child: Consumer<MasterResultProvider>(
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
                                  SizedBox(height: 20),
                                  (value.score < Constants.minimumSubmitScore)
                                      ? SizedBox(
                                          width: double.infinity,
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(w(0.04)),
                                              child: Wrap(
                                                spacing: w(0.013),
                                                children: value
                                                    .speechEvaluationModel!
                                                    .result!
                                                    .words!
                                                    .map(
                                                      (word) => Text(
                                                        word.word ?? "",
                                                        style: AppTextStyles
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                              fontSize: w(0.06),
                                                              color: value
                                                                  .getWordColor(
                                                                    word.scores?.overall ??
                                                                        0,
                                                                  ),
                                                            ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: w(0.40),
                                          height: h(0.18),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                ImageConstants.loginBg,
                                              ),
                                            ),
                                          ),
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
                                        value.gptResponse?.title ?? "",
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
                                            text: value.gptResponse?.body,
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
                                                child: Text(
                                                  value
                                                          .gptResponse
                                                          ?.microDrill ??
                                                      "",
                                                  style: AppTextStyles
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        color: Colors.black,
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
                                          onPressed: () => context.pop(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                value
                                                    .language
                                                    .gradient
                                                    ?.first ??
                                                Colors.blue,
                                          ),
                                          child: Text(
                                            text.retry,
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
                                      Spacer(),
                                      Text(
                                        value.gptResponse?.title ?? '',
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      Text(
                                        text.masteredIt,
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      Spacer(),
                                      Text(
                                        value.gptResponse?.body ?? '',
                                        style: AppTextStyles
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.black),
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
                                                  "streak": 1,
                                                  "from": "learned",
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
                          Spacer(flex: 1),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height / 5,
                            width: double.infinity,
                            child: RiveAnimation.asset(
                              'assets/animation/confetti.riv',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height / 5,
                            width: double.infinity,
                            child: Image.asset(ImageConstants.buddha),
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
