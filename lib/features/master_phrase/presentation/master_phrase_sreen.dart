import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_provider.dart';
import 'package:yoyo_school_app/features/recording/presentation/remember_and_practise_screen.dart';

import '../../../config/constants/constants.dart';
import '../../home/model/school_launguage.dart';

class MasterPhraseSreen extends StatelessWidget {
  final PhraseModel model;
  final int? streak;
  final SchoolLanguage schoolLanguage;
  final String className;
  final Student student;
  final bool isLast;
  const MasterPhraseSreen({
    super.key,
    required this.model,
    this.streak,
    required this.schoolLanguage,
    required this.className,
    required this.student,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    double w(double factor) => width * factor;
    double h(double factor) => height * factor;
    return Consumer<MasterPhraseProvider>(
      builder: (context, value, child) => Stack(
        children: [
          Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: value.isLoading
                ? Container()
                : Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: value.language?.gradient ?? [],
                        begin: AlignmentGeometry.topLeft,
                        end: AlignmentGeometry.bottomRight,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: h(0.03)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w(0.07)),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: backBtn(
                                streak: streak != null,
                                context: context,
                                slanguage: schoolLanguage,
                                className: className,
                                student: student,
                                categories: value.categories,
                              ),
                            ),
                          ),
                          SizedBox(height: h(0.02)),
                          if (model.questions != null)
                            Column(
                              spacing: 20,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 29.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),

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
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28.0,
                                      vertical: 20,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          value.phraseModel.questions ?? "",
                                          maxLines: 3,
                                          textAlign: TextAlign.left,
                                          style: AppTextStyles
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            splashColor:
                                                value.language?.gradient?.first
                                                    .withValues(alpha: 0.2) ??
                                                Colors.grey.withValues(
                                                  alpha: 0.2,
                                                ),
                                            onTap: () async =>
                                                await value.playQuestionAudio(),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.play_arrow_rounded,
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: h(0.02)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: w(0.07)),
                            child: Row(
                              spacing: 10,
                              children: [
                                Text(
                                  text.canYouMasterIT,
                                  style: AppTextStyles.textTheme.headlineMedium!
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  text.sayTheAnswer,
                                  style: AppTextStyles.textTheme.titleSmall!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h(0.02)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 29.0,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(15),
                              height: h(0.2),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        value.language?.gradient?.first ??
                                        Colors.white,
                                    blurRadius: 5,
                                  ),

                                  BoxShadow(
                                    color:
                                        value.language?.gradient?.last ??
                                        Colors.white,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'A',
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                              color:
                                                  value
                                                      .language
                                                      ?.gradient
                                                      ?.first ??
                                                  Colors.white,
                                            ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.translate_rounded),
                                      ),
                                      Expanded(
                                        child: Text(
                                          value.phraseModel.translation ?? '',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(50),
                                      splashColor:
                                          value.language?.gradient?.first
                                              .withValues(alpha: 0.2) ??
                                          Colors.grey.withValues(alpha: 0.2),
                                      onTap: () async {
                                        value.playAudio();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.play_arrow_outlined,
                                          size: 50,
                                        ),
                                      ),
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
                                          color: Colors.white,
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
                                              color: Colors.white,
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

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    value.language?.image ?? "",
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            bottomNavigationBar: value.language != null
                ? RememberAndPractiseScreen(
                    model: model,
                    launguage: value.language!,
                    streak: streak,
                    isLast: isLast,
                  )
                : Container(),
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
