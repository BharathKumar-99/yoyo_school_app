import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';

import '../../../config/constants/constants.dart';
import '../../../config/router/navigation_helper.dart';
import '../../../config/utils/usefull_functions.dart';
import '../../../core/widgets/app_bar.dart';
import '../../home/model/level_model.dart';
import '../../home/model/school_launguage.dart';
import 'phrase_categories_view_model.dart';

class PhraseCategories extends StatelessWidget {
  final SchoolLanguage language;
  final Student? student;
  final String className;
  final List<Level> levels;
  const PhraseCategories({
    super.key,
    required this.language,
    required this.className,
    required this.levels,
    this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<PhraseCategoriesViewModel>(
        create: (_) => PhraseCategoriesViewModel(language, student),
        child: Consumer<PhraseCategoriesViewModel>(
          builder: (context, provider, child) => provider.isLoading
              ? Container()
              : Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 2.4,
                      child: Hero(
                        tag: language.language?.language ?? "",
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors:
                                    provider.classes.language?.gradient ?? [],
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
                            child: Stack(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height / 2.4,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 100),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(16),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  provider
                                                      .classes
                                                      .language
                                                      ?.image ??
                                                  "",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height / 2.4,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          child: getAppBar(context),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 20),
                                              Text(
                                                provider
                                                        .classes
                                                        .language
                                                        ?.language ??
                                                    "",
                                                style: AppTextStyles
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              Text(
                                                className,
                                                style: AppTextStyles
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              Text(
                                                "${text.level}${UsefullFunctions.returnLevel(provider.classes.language?.level ?? 0, levels)}",
                                                style: AppTextStyles
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        text.classText,
                                                        style: AppTextStyles
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Container(
                                                            height: 60,
                                                            width: 60,
                                                            decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        100,
                                                                      ),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                          Container(
                                                            height: 55,
                                                            width: 55,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    100,
                                                                  ),
                                                              image: DecorationImage(
                                                                image: AssetImage(
                                                                  ImageConstants
                                                                      .loginBg,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '${provider.classPercentage}%',
                                                                style: AppTextStyles
                                                                    .textTheme
                                                                    .bodyLarge!
                                                                    .copyWith(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        text.you,
                                                        style: AppTextStyles
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Container(
                                                        height: 55,
                                                        width: 55,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                100,
                                                              ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${provider.userPercentage}%',
                                                            style: AppTextStyles
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                            ],
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
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(left: 23, right: 23),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            spacing: 20,
                            children: [
                              SizedBox(height: 5),
                              if (provider.globalProvider?.apiCred.warmUp ??
                                  false)
                                GestureDetector(
                                  onTap: () => NavigationHelper.go(
                                    RouteNames.phrasesDetails,
                                    extra: {
                                      'language': language,
                                      "className": text.warmUp,
                                      "level": levels,
                                      'student': student,
                                      'categories': -1,
                                    },
                                  ),
                                  child: getWarmUpCard(language),
                                ),

                              ...provider.phraseCategories.map(
                                (val) => GestureDetector(
                                  onTap: () {
                                    NavigationHelper.go(
                                      RouteNames.phrasesDetails,
                                      extra: {
                                        'language': language,
                                        "className": val.name ?? '',
                                        "level": levels,
                                        'student': student,
                                        'categories': val.id,
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),

                                      gradient: LinearGradient(
                                        colors:
                                            provider
                                                .classes
                                                .language
                                                ?.gradient ??
                                            [],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Stack(
                                        children: [
                                          (val.image != null)
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: CachedNetworkImage(
                                                    imageUrl: val.image ?? '',
                                                    height: 150,
                                                    width: 120,
                                                  ),
                                                )
                                              : Container(),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              val.name ?? '',
                                              textAlign: TextAlign.left,
                                              style: AppTextStyles
                                                  .textTheme
                                                  .headlineMedium!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontFamily: 'Sansita',
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => NavigationHelper.go(
                                  RouteNames.phrasesDetails,
                                  extra: {
                                    'language': language,
                                    "className": text.phrases,
                                    "level": levels,
                                    'student': student,
                                    'categories': 0,
                                  },
                                ),
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors:
                                          provider.classes.language?.gradient ??
                                          [],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          text.phrases,
                                          style: AppTextStyles
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontFamily: 'Sansita',
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
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  getWarmUpCard(SchoolLanguage val) {
    switch (val.language?.id) {
      case 2:
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFF2614B),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text.warmUp,
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: 'Sansita',
                  ),
                ),
                Image.asset(ImageConstants.spanishWarmup),
              ],
            ),
          ),
        );
      case 3:
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFA15F98),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(ImageConstants.frenchWarmup),
                Text(
                  text.warmUp,
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: 'Sansita',
                  ),
                ),
              ],
            ),
          ),
        );
      case 4:
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF962F4A),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text.warmUp,
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: 'Sansita',
                  ),
                ),
                Image.asset(ImageConstants.germanWarmup),
              ],
            ),
          ),
        );
      case 5:
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF99223C),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(ImageConstants.koreanWarmup),
                Text(
                  text.warmUp,
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: 'Sansita',
                  ),
                ),
              ],
            ),
          ),
        );
      case 1:
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF99223C),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(ImageConstants.russiaWarmup),
                Text(
                  text.warmUp,
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: 'Sansita',
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: val.language?.gradient?.first ?? Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(
                  text.warmUp,
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: 'Sansita',
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
