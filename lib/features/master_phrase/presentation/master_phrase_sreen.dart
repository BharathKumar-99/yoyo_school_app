import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/back_btn.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_provider.dart';
import 'package:yoyo_school_app/features/recording/presentation/remember_and_practise_screen.dart';

import '../../../config/constants/constants.dart';

class MasterPhraseSreen extends StatelessWidget {
  final PhraseModel model;
  final int? streak;

  const MasterPhraseSreen({super.key, required this.model, this.streak});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    double w(double factor) => width * factor;
    double h(double factor) => height * factor;
    return ChangeNotifierProvider<MasterPhraseProvider>(
      create: (_) => MasterPhraseProvider(model),
      child: Consumer<MasterPhraseProvider>(
        builder: (context, value, child) => Scaffold(
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
                            child: backBtn(),
                          ),
                        ),
                        SizedBox(height: h(0.02)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: w(0.07)),
                          child: Text(
                            text.canYouMasterIT,
                            style: AppTextStyles.textTheme.headlineMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: h(0.02)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 29.0),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            height: h(0.3),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                        if (streak != null)
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
                                        color: Colors.deepPurple,
                                        fontFamily: 'Sansita',
                                      ),
                                ),
                                Row(
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
                                      height: 80,
                                      width: 80,
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
                )
              : Container(),
        ),
      ),
    );
  }
}
