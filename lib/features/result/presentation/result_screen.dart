import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/result/presentation/result_provider.dart';

class ResultScreen extends StatelessWidget {
  final PhraseModel phraseModel;
  final Language language;
  final String audioPath;
  const ResultScreen({
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

    return ChangeNotifierProvider<ResultProvider>(
      create: (_) => ResultProvider(phraseModel, audioPath, language),
      child: Consumer<ResultProvider>(
        builder: (context, value, child) => Scaffold(
          body: value.speechEvaluationModel == null
              ? Container()
              : Stack(
                  children: [
                    Container(
                      height: h(0.4),
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: language.gradient ?? [],
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
                      child: Column(
                        children: [
                          SizedBox(height: h(0.12)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: CachedNetworkImage(
                                width: width,
                                imageUrl: value.language.image ?? '',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w(0.07),
                            vertical: h(0.065),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: backBtn(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: w(0.07)),
                          child: Column(
                            children: [
                              Text(
                                value.resultTest,
                                style: AppTextStyles.textTheme.headlineMedium!
                                    .copyWith(color: Colors.white),
                              ),
                              SizedBox(height: h(0.05)),
                              Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(w(0.04)),
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
                                                      word.word ?? "",
                                                      style: AppTextStyles
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontSize: w(
                                                              0.06,
                                                            ), // 24
                                                            color: value
                                                                .getWordColor(
                                                                  word
                                                                          .scores
                                                                          ?.overall ??
                                                                      0,
                                                                ),
                                                          ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                            SizedBox(height: h(0.04)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -h(0.17),
                                    child: Container(
                                      width: w(0.45),
                                      height: h(0.23),
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
                                          '${value.speechEvaluationModel?.result?.overall.toString() ?? '0'} %',
                                          style: AppTextStyles
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: w(0.16),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: h(0.23)),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  fixedSize: Size(w(0.32), h(0.12)),
                                  iconSize: w(0.18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {},
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: h(0.04)),
                              if ((value
                                          .speechEvaluationModel
                                          ?.result
                                          ?.overall ??
                                      0) >=
                                  Constants.minimumSubmitScore)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => value.upsertResult(
                                      value
                                              .speechEvaluationModel
                                              ?.result
                                              ?.overall ??
                                          0,
                                      submit: true,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          value.language.gradient?.first ??
                                          Colors.blue,
                                    ),
                                    child: Text(
                                      text.submit_score,
                                      style:
                                          AppTextStyles.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                              SizedBox(height: h(0.04)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
