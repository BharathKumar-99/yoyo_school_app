import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import '../../home/model/language_model.dart';
import '../../home/model/phrases_model.dart';
import 'streak_recording_view_model.dart';
import 'widgets/widgets.dart';

class StreakRecordingPopup extends StatelessWidget {
  final PhraseModel phraseModel;
  final Language launguage;
  final String audioPath;
  final int streak;
  final String form;
  final bool isLast;
  const StreakRecordingPopup({
    super.key,
    required this.phraseModel,
    required this.launguage,
    required this.audioPath,
    required this.streak,
    required this.form,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StreakRecordingViewModel>(
      create: (_) => StreakRecordingViewModel(
        phraseModel,
        audioPath,
        launguage,
        streak,
        form,
        isLast,
      ),
      child: Consumer<StreakRecordingViewModel>(
        builder: (context, value, child) => value.loading
            ? Container(
                height: MediaQuery.sizeOf(context).height / 3,
                decoration: BoxDecoration(
                  color: launguage.gradient?.first ?? Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 200,
                      child: Lottie.asset(
                        AnimationAsset.yoyoWaitingText,
                        fit: BoxFit.fill,
                      ),
                    ),
                    CheckingDots(),
                    Spacer(),
                  ],
                ),
              )
            : value.score > Constants.minimumSubmitScore
            ? Container(
                height: MediaQuery.sizeOf(context).height / 3,
                decoration: BoxDecoration(
                  color: Color(0xff34A853),
                  borderRadius: BorderRadius.circular(16),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Spacer(),
                    Lottie.asset(
                      AnimationAsset.streakTick,
                      fit: BoxFit.cover,
                      height: 120,
                    ),

                    Text(
                      '${value.score}%',
                      style: AppTextStyles.textTheme.titleLarge!.copyWith(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),

                    Text(
                      text.niceWork,
                      style: AppTextStyles.textTheme.titleLarge!.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )
            : Container(
                height: MediaQuery.sizeOf(context).height / 3,
                decoration: BoxDecoration(
                  color: launguage.gradient?.first ?? Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      text.ohNoNotThis,
                      style: AppTextStyles.textTheme.titleLarge!.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      text.yourStreakWas,
                      style: AppTextStyles.textTheme.titleLarge!.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 100,
                      width: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageConstants.star),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              value.streak.toString(),
                              style: AppTextStyles.textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Sansita',
                                    color:
                                        launguage.gradient?.first ??
                                        Colors.white,
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
    );
  }
}
