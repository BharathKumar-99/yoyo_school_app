import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/app_bar.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/listen_and_type/presentation/widgets/fake_wave.dart';
import 'package:yoyo_school_app/features/phrases/presentation/phrases_view_model.dart';

import '../../home/model/level_model.dart';
import '../../home/model/student_model.dart';

class PhrasesDetails extends StatelessWidget {
  final Language language;
  final Student? student;
  final String className;
  final List<Level> levels;
  final bool? next;
  final int? streak;
  final String? from;
  final int? streakPhraseId;
  final int categories;
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
    required this.categories,
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
        categories,
        context,
      ),
      child: Consumer<PhrasesViewModel>(
        builder: (context, provider, wi) {
          return provider.isStreakLoading
              ? Container(color: Colors.white)
              : DefaultTabController(
                  length: provider.isMasteryEnabled ? 3 : 2,
                  child: Scaffold(
                    body: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height / 2.4,
                            child: Hero(
                              tag: language.language ?? "",
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  decoration: TextDecoration.none,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                      colors: provider.language.gradient ?? [],
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
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(16),
                                                      ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        provider
                                                            .language
                                                            .image ??
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
                                            2.6,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 120,
                                              child: getAppBar(context),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  16.0,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Spacer(),
                                                    Text(
                                                      className,
                                                      style: AppTextStyles
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Sansita',
                                                          ),
                                                    ),
                                                    Spacer(),
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
                                                              alignment:
                                                                  Alignment
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
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          NavigationHelper.go(
                                                            RouteNames
                                                                .phraseCategories,
                                                            extra: {
                                                              'language':
                                                                  language,
                                                              "className":
                                                                  className,
                                                              "level": levels,
                                                              'student':
                                                                  student,
                                                            },
                                                          ),
                                                      child: Text(
                                                        text.back,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (((provider.streakNumber ?? 0) > 0) &&
                                          (provider
                                                  .globalProvider
                                                  .apiCred
                                                  ?.streak ??
                                              false))
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                                  FontWeight
                                                                      .bold,
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
                                    provider.language.gradient?.first ??
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
                                if (provider.isMasteryEnabled)
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
                                goToNext: provider.isMasteryEnabled,
                              ),
                              if (provider.isMasteryEnabled)
                                _buildPhrasesList(
                                  provider.mastered,
                                  provider,
                                  context,
                                  RouteNames.masterPhrases,
                                  showPercentage: true,
                                  goToNext: false,
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
    bool goToNext = true,
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
              onTap: () {
                if (goToNext) {
                  if (model.listen ?? false) {
                    context.go(
                      RouteNames.listenAndTypeScreen,
                      extra: {
                        "phrase": model,
                        "language": provider.language,
                        "className": className,
                        "student": provider.student,
                        'categories': categories,
                      },
                    );
                  } else {
                    context.go(
                      routeName,
                      extra: {
                        "phrase": model,
                        "streak": provider.streak,
                        "language": provider.language,
                        "className": className,
                        "student": provider.student,
                        "isLast": phrases.length == 1,
                        'categories': categories,
                      },
                    );
                  }
                }
              },
              child: PhrasesWidget(
                title: model.phrase ?? "",
                subTitle: model.translation ?? "",
                launguage: provider.language,
                precentage: percentage,
                onIconTap: () {
                  provider.playAudio(model);
                },
                question: model.questions,
                listen: model.listen,
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
  final String? question;
  final bool? listen;

  const PhrasesWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.precentage,
    this.launguage,
    required this.onIconTap,
    this.question,
    this.listen,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PhrasesViewModel>(
      builder: (context, provider, w) {
        return Column(
          children: [
            if (question != null)
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 26),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xEBE8EBFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: AutoSizeText(
                  question ?? '',
                  maxLines: 3,
                  style: AppTextStyles.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            Container(
              height: 140,
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
                                style: AppTextStyles.textTheme.bodyLarge!
                                    .copyWith(color: Colors.black),
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
                      child: (listen ?? false)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      'Mystery Phrase',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.textTheme.bodyLarge,
                                    ),
                                    AutoSizeText(
                                      'Listen and type',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                FakeWaveform(
                                  isPlaying:
                                      provider.currentlyPlaying?.phrase ==
                                          title &&
                                      provider.isPlaying,
                                  height: 30,
                                  color: Colors.black,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  title,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.textTheme.titleLarge,
                                ),
                                AutoSizeText(
                                  subTitle,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
