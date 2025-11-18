import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/core/widgets/app_bar.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/phrases/presentation/phrases_view_model.dart';

import '../../home/model/level_model.dart';
import '../../home/model/school_launguage.dart';
import '../../home/model/student_model.dart';

class PhrasesDetails extends StatelessWidget {
  final SchoolLanguage language;
  final Student? student;
  final String className;
  final List<Level> levels;
  final bool? next;
  final int? streak;
  final String? from;
  final int? streakPhraseId;
  const PhrasesDetails({
    super.key,
    required this.language,
    required this.className,
    required this.levels,
    this.student,
    this.next,
    this.streak,
    this.from,
    this.streakPhraseId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhrasesViewModel>(
      create: (_) => PhrasesViewModel(
        language,
        student,
        next ?? false,
        streak,
        from,
        context,
        className,
        streakPhraseId,
      ),
      child: Consumer<PhrasesViewModel>(
        builder: (context, provider, wi) {
          return provider.isStreakLoading
              ? Container(color: Colors.white)
              : DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height / 2.4,
                            child: Hero(
                              tag: language.language?.language ?? "",
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors:
                                        provider.classes.language?.gradient ??
                                        [],
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
                                          MediaQuery.sizeOf(context).height /
                                          2.4,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 100),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(
                                                    16,
                                                  ),
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
                                          MediaQuery.sizeOf(context).height /
                                          2.4,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 120,
                                              child: getAppBar(context),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
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
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Container(
                                                                height: 60,
                                                                width: 60,
                                                                decoration: BoxDecoration(
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
                                                                          color:
                                                                              Colors.white,
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
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Container(
                                                            height: 55,
                                                            width: 55,
                                                            decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        100,
                                                                      ),
                                                                  color: Colors
                                                                      .white,
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
                                    if (((provider.streakNumber ?? 0) > 0) &&
                                        provider.globalProvider.apiCred.streak)
                                      Positioned(
                                        bottom: 0,
                                        right:
                                            MediaQuery.sizeOf(context).width /
                                            3.5,
                                        left:
                                            MediaQuery.sizeOf(context).width /
                                            3.1,
                                        child: Column(
                                          children: [
                                            Text(
                                              text.streak,
                                              style: AppTextStyles
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontFamily: 'Sansita',
                                                  ),
                                            ),
                                            Container(
                                              height: 100,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    ImageConstants.star,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              child: Center(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 16.0,
                                                        ),
                                                    child: Text(
                                                      provider.streakNumber
                                                          .toString(),
                                                      style: AppTextStyles
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Sansita',
                                                            color: Colors
                                                                .deepPurple,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 30)),

                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding: EdgeInsetsGeometry.symmetric(
                                horizontal: 10,
                              ),
                              indicator: BoxDecoration(
                                color:
                                    provider
                                        .classes
                                        .language
                                        ?.gradient
                                        ?.first ??
                                    Colors.amberAccent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              dividerColor: Colors.transparent,
                              tabs: [
                                Tab(
                                  text:
                                      "${text.newText} (${provider.newPhrases.length})",
                                ),
                                Tab(
                                  text:
                                      "${text.learned} (${provider.learned.length})",
                                ),
                                Tab(
                                  text:
                                      "${text.mastered} (${provider.mastered.length})",
                                ),
                              ],
                            ),
                          ),
                        ),

                        SliverFillRemaining(
                          child: TabBarView(
                            children: [
                              _buildPhrasesList(
                                provider.newPhrases,
                                provider,
                                context,
                                RouteNames.tryPhrases,
                              ),
                              _buildPhrasesList(
                                provider.learned,
                                provider,
                                context,
                                RouteNames.masterPhrases,
                                showPercentage: true,
                              ),
                              _buildPhrasesList(
                                provider.mastered,
                                provider,
                                context,
                                RouteNames.masterPhrases,
                                showPercentage: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildPhrasesList(
    List<PhraseModel> phrases,
    PhrasesViewModel provider,
    BuildContext context,

    String routeName, {
    bool showPercentage = false,
  }) {
    if (phrases.isEmpty) {
      return Center(child: Text(text.empty_list));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
      physics: BouncingScrollPhysics(),
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        final model = phrases[index];
        String? percentage;
        if (showPercentage) {
          final result = provider.userResult.firstWhere(
            (val) => val.phrasesId == model.id,
          );
          percentage = "${result.score}%";
        }
        return Column(
          children: [
            GestureDetector(
              onTap: () => context.go(
                routeName,
                extra: {
                  "phrase": model,
                  "streak": provider.streak,
                  "schoolLanguage": provider.classes,
                  "className": className,
                  "student": provider.student,
                  "isLast": phrases.length == 1,
                  "language": provider.classes.language,
                },
              ),
              child: PhrasesWidget(
                title: model.phrase ?? "",
                subTitle: model.translation ?? "",
                launguage: provider.classes.language,
                precentage: percentage,
                onIconTap: () {
                  provider.playAudio(model);
                },
              ),
            ),
            if (showPercentage == true)
              GestureDetector(
                onTap: () async {
                  await provider.resetPhrase(model.id);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.refresh_rounded),
                      Text(
                        text.learnAgain,
                        style: AppTextStyles.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 20),
    );
  }
}

class PhrasesWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? precentage;
  final Language? launguage;
  final VoidCallback onIconTap;

  const PhrasesWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.precentage,
    this.launguage,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFFFC3FE)),
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: launguage?.gradient ?? [Colors.white],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (precentage != null)
                  Container(
                    height: 55,
                    width: 55,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        precentage!,
                        style: AppTextStyles.textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    onIconTap();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AbsorbPointer(
                    absorbing: false,
                    child: Icon(
                      Icons.play_arrow_outlined,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: AppTextStyles.textTheme.titleLarge,
                  ),
                  Text(
                    subTitle,
                    maxLines: 2,
                    style: AppTextStyles.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => true;
}
