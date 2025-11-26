import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
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

  // Extracted Header Widget for cleaner build method
  Widget _buildHeader(
    BuildContext context,
    PhrasesViewModel provider,
    double headerHeight,
  ) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: headerHeight,
      pinned: false,
      elevation: 0,
      backgroundColor: Colors.transparent, // To show gradient below
      flexibleSpace: Hero(
        tag: language.language?.language ?? "",
        child: DefaultTextStyle(
          style: const TextStyle(decoration: TextDecoration.none),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: provider.classes.language?.gradient ?? [],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(70),
                  spreadRadius: 5,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Image
                SizedBox(
                  height: headerHeight,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ), // Space for app bar and padding
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: provider.classes.language?.image ?? "",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Foreground Content
                SizedBox(
                  height: headerHeight,
                  child: Column(
                    children: [
                      SizedBox(height: 120, child: getAppBar(context)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              Text(
                                className,
                                style: AppTextStyles.textTheme.bodyLarge
                                    ?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Sansita',
                                    ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Class Percentage
                                  _buildPercentageBadge(
                                    context,
                                    text.classText,
                                    '${provider.classPercentage}%',
                                    isClass: true,
                                  ),
                                  // User Percentage
                                  _buildPercentageBadge(
                                    context,
                                    text.you,
                                    '${provider.userPercentage}%',
                                    isClass: false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Streak Widget
                if (((provider.streakNumber ?? 0) > 0) &&
                    provider.globalProvider.apiCred.streak)
                  Positioned(
                    bottom: 0,
                    right: MediaQuery.sizeOf(context).width / 3.5,
                    left: MediaQuery.sizeOf(context).width / 3.1,
                    child: Column(
                      children: [
                        Text(
                          text.streak,
                          style: AppTextStyles.textTheme.bodyLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Sansita',
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 130,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageConstants.star),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  provider.streakNumber.toString(),
                                  style: AppTextStyles.textTheme.bodyLarge
                                      ?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Sansita',
                                        color: Colors.deepPurple,
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
    );
  }

  // Extracted Percentage Badge Widget
  Widget _buildPercentageBadge(
    BuildContext context,
    String label,
    String percentage, {
    required bool isClass,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.textTheme.headlineSmall!.copyWith(
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 5),
        // For the class badge, the design requires a Stack with an outer white ring
        if (isClass)
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
              ),
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(
                    image: AssetImage(ImageConstants.loginBg),
                  ),
                ),
                child: Center(
                  child: Text(
                    percentage,
                    style: AppTextStyles.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        // For the user badge, it's a simple white background
        else
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                percentage,
                style: AppTextStyles.textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the height of the custom header section
    final double headerHeight = MediaQuery.sizeOf(context).height / 2.4;

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
      ),
      child: Consumer<PhrasesViewModel>(
        builder: (context, provider, wi) {
          if (provider.isStreakLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return DefaultTabController(
            length: provider.isMasteryEnabled ? 3 : 2,
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    _buildHeader(context, provider, headerHeight),

                    SliverToBoxAdapter(child: const SizedBox(height: 30)),

                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          indicator: BoxDecoration(
                            color:
                                provider.classes.language?.gradient?.first ??
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
                        backgroundColor: Theme.of(
                          context,
                        ).scaffoldBackgroundColor,
                      ),
                    ),
                  ];
                },
                // The body is the TabBarView, which scrolls independently beneath the header
                body: TabBarView(
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
                      haltNextScreen: !provider.isMasteryEnabled,
                    ),
                    if (provider.isMasteryEnabled)
                      _buildPhrasesList(
                        provider.mastered,
                        provider,
                        context,
                        RouteNames.masterPhrases,
                        showPercentage: true,
                        haltNextScreen: true,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Phrases List Builder (Unchanged)
  Widget _buildPhrasesList(
    List<PhraseModel> phrases,
    PhrasesViewModel provider,
    BuildContext context,
    String routeName, {
    bool showPercentage = false,
    bool haltNextScreen = false,
  }) {
    if (phrases.isEmpty) {
      return Center(child: Text(text.empty_list));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
      physics: const BouncingScrollPhysics(),
      itemCount: phrases.length,
      itemBuilder: (context, index) {
        final model = phrases[index];
        String? percentage;
        if (showPercentage) {
          // Use firstWhereOrNull for safer access (requires 'package:collection')
          final result = provider.userResult.firstWhereOrNull(
            (val) => val.phrasesId == model.id,
          );
          percentage = (result != null) ? "${result.score}%" : null;
        }
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                if (!haltNextScreen) {
                  context.go(
                    routeName,
                    extra: {
                      "phrase": model,
                      "streak": provider.streak,
                      "schoolLanguage": provider.classes,
                      "className": className,
                      "student": provider.student,
                      "isLast": phrases.length == 1,
                      "language": provider.classes.language,
                      'categories': categories,
                    },
                  );
                }
              },
              child: PhrasesWidget(
                title: model.phrase ?? "",
                subTitle: model.translation ?? "",
                launguage: provider.classes.language,
                precentage: percentage,
                onIconTap: () {
                  provider.playAudio(model);
                },
                question: model.questions,
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
                      const Icon(Icons.refresh_rounded),
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
      separatorBuilder: (_, __) => const SizedBox(height: 20),
    );
  }
}

// PhrasesWidget (Unchanged, good structure)
class PhrasesWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? precentage;
  final Language? launguage;
  final VoidCallback onIconTap;
  final String? question;

  const PhrasesWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.precentage,
    this.launguage,
    required this.onIconTap,
    this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (question != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 26),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xEBE8EBFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: AutoSizeText(
              question!,
              maxLines: 3,
              style: AppTextStyles.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFFC3FE)),

            borderRadius: question == null
                ? BorderRadius.circular(16)
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
          ),
          child: Row(
            children: [
              Container(
                width: 76,
                decoration: BoxDecoration(
                  // Update borderRadius to match container's
                  borderRadius: question == null
                      ? BorderRadius.circular(16)
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          topLeft: Radius.circular(0),
                        ),
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
                        margin: const EdgeInsets.only(top: 20),
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
                      onTap: onIconTap,
                      behavior: HitTestBehavior.opaque,
                      child: const AbsorbPointer(
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
  }
}

// Sliver Persistent Header Delegate (Updated to accept background color)
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color backgroundColor;

  const _SliverAppBarDelegate(this._tabBar, {required this.backgroundColor});

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
    return Container(
      color: backgroundColor, // Apply background color for visibility
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate._tabBar != _tabBar;
}
