import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/core/widgets/app_bar.dart';
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
  const PhrasesDetails({
    super.key,
    required this.language,
    required this.className,
    required this.levels,
    this.student,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PhrasesViewModel>(
      create: (_) => PhrasesViewModel(language),
      child: Consumer<PhrasesViewModel>(
        builder: (context, provider, wi) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  // Hero container
                  SliverToBoxAdapter(
                    child: Hero(
                      tag: language.language?.language ?? "",
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
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 100),
                                SizedBox(
                                  height: 250,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            provider.classes.language?.image ??
                                            "",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(height: 120, child: getAppBar(context)),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        provider.classes.language?.language ??
                                            "",
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        className,
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        "${text.level}${UsefullFunctions.returnLevel(provider.classes.language?.level ?? 0, levels)}",
                                        style: AppTextStyles
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                text.classText,
                                                style: AppTextStyles
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              SizedBox(width: 5),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100,
                                                          ),
                                                      color: Colors.white,
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
                                                        "88%",
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                text.you,
                                                style: AppTextStyles
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                      color: Colors.white,
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
                                                    "0%",
                                                    style: AppTextStyles
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color: Colors.black,
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
                          ],
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
                        dividerColor: Colors.transparent,
                        unselectedLabelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 1,
                        indicatorPadding: EdgeInsetsGeometry.symmetric(
                          horizontal: 26,
                        ),
                        indicator: BoxDecoration(
                          color:
                              provider.classes.language?.gradient?.first ??
                              Colors.amberAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        tabs: [
                          Tab(
                            text:
                                "${text.newText} (${provider.classes.language?.phrase?.length})",
                          ),
                          Tab(
                            text:
                                "${text.recorded} (${student?.attemptedPhrases?.where((val) => val.phrase?.level == language.language?.level && language.language?.id == val.phrase?.language).length}) ",
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverFillRemaining(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              PhraseModel? model =
                                  provider.classes.language?.phrase?[index];
                              return PhrasesWidget(
                                title: model?.phrase ?? "",
                                subTitle: model?.translation ?? "",
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 20);
                            },
                            itemCount:
                                provider.classes.language?.phrase?.length ?? 0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return PhrasesWidget(
                                title: "¿Puedes repetir eso por favor?",
                                subTitle: "can you repeat that Please?",
                                precentage: "88%",
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 20);
                            },
                            itemCount: 5,
                          ),
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
}

class PhrasesWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? precentage;
  const PhrasesWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.precentage,
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
                colors: [Color(0xFFEF2E36), Color(0xFFFEE37F)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.play_arrow_outlined,
                    size: 35,
                    color: Colors.white,
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
                    style: AppTextStyles.textTheme.bodyMedium,
                    maxLines: 2,
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

// Helper class for pinned Sliver TabBar
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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
