import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/core/widgets/app_bar.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/school_launguage.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeScreenProvider>(
      create: (context) => HomeScreenProvider(HomeRepository()),
      child: Consumer<HomeScreenProvider>(
        builder: (context, homeProvider, wi) {
          return Scaffold(
            body: SafeArea(
              top: false,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    toolbarHeight: 80,
                    flexibleSpace: getAppBar(context),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 10),
                        _AnimatedSectionTitle(text.your_metrics),
                        const SizedBox(height: 10),
                        _AnimatedRow(
                          delay: 200,
                          children: [
                            getMetricCard(
                              text.phrases,
                              "${homeProvider.atemptedPhrases}/${homeProvider.totalPhrases}",
                              (homeProvider.atemptedPhrases) >
                                      (homeProvider.totalPhrases / 2)
                                  ? Colors.green.shade700
                                  : Colors.orangeAccent,
                            ),
                            getMetricCard(
                              text.vocab,
                              homeProvider.student?.vocab.toString() ?? "0",
                              (homeProvider.student?.vocab ?? 0) >
                                      Constants.minimumSubmitScore
                                  ? Colors.green.shade700
                                  : Colors.orangeAccent,
                            ),
                            getMetricCard(
                              text.effort,
                              "${homeProvider.student?.effort.toString() ?? "0"}% ",
                              (homeProvider.student?.effort ?? 0) >
                                      Constants.minimumSubmitScore
                                  ? Colors.green.shade700
                                  : Colors.orangeAccent,
                            ),
                            getMetricCard(
                              text.score,
                              "${homeProvider.student?.score.toString() ?? "0"}%",
                              (homeProvider.student?.score ?? 0) >
                                      Constants.minimumSubmitScore
                                  ? Colors.green.shade700
                                  : Colors.orangeAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        _AnimatedSectionTitle(text.your_classes),
                        const SizedBox(height: 10),
                        Column(
                          children:
                              homeProvider
                                  .userClases
                                  ?.classes
                                  ?.school
                                  ?.schoolLanguage
                                  ?.asMap()
                                  .entries
                                  .map(
                                    (entry) => _AnimatedCard(
                                      delay: 300 * entry.key,
                                      child: LaunguageCard(
                                        student: homeProvider.userClases,
                                        language: entry.value,
                                        level: homeProvider.levels ?? [],
                                        className:
                                            homeProvider
                                                .userClases
                                                ?.classes
                                                ?.className ??
                                            "",
                                      ),
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                        const SizedBox(height: 30),
                      ]),
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

/// 🌟 Fade + Slide-in for section headers
class _AnimatedSectionTitle extends StatelessWidget {
  final String title;
  const _AnimatedSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Text(title, style: AppTextStyles.textTheme.headlineLarge),
          ),
        );
      },
    );
  }
}

/// 🌟 Fade + Slide-in for row of metrics
class _AnimatedRow extends StatelessWidget {
  final List<Widget> children;
  final int delay;
  const _AnimatedRow({required this.children, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

/// 🌟 Subtle fade-in + upward slide for each language card
class _AnimatedCard extends StatelessWidget {
  final Widget child;
  final int delay;
  const _AnimatedCard({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}

class LaunguageCard extends StatefulWidget {
  final Student? student;
  final SchoolLanguage? language;
  final String className;
  final List<Level> level;

  const LaunguageCard({
    super.key,
    required this.language,
    required this.className,
    required this.student,
    required this.level,
  });

  @override
  State<LaunguageCard> createState() => _LaunguageCardState();
}

class _LaunguageCardState extends State<LaunguageCard> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: () => setState(() => _scale = 1.0),
          onTap: () => NavigationHelper.push(
            RouteNames.phrasesDetails,
            extra: {
              'language': widget.language,
              "className": widget.className,
              "level": widget.level,
              'student': widget.student,
            },
          ),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: Hero(
              tag: widget.language?.language?.language ?? "",
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                shadowColor: Colors.black26,
                child: Container(
                  height: 151,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: widget.language?.language?.gradient ?? [],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 157,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.language?.language?.image ?? "",
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.language?.language?.language ?? "",
                              style: AppTextStyles.textTheme.headlineSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              widget.className,
                              style: AppTextStyles.textTheme.headlineSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              "${text.level}${UsefullFunctions.returnLevel(widget.language?.language?.level ?? 0, widget.level)}",
                              style: AppTextStyles.textTheme.headlineSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              "${widget.student?.attemptedPhrases?.where((val) => val.phrase?.level == widget.language?.language?.level && widget.language?.language?.id == val.phrase?.language).length} / ${widget.language?.language?.phrase?.length ?? 0}  ${text.phrases}",
                              style: AppTextStyles.textTheme.titleMedium!
                                  .copyWith(color: Colors.white),
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
        const SizedBox(height: 30),
      ],
    );
  }
}

Column getMetricCard(String title, String data, Color bgColor) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(title, style: AppTextStyles.textTheme.titleMedium),
    const SizedBox(height: 10),
    Container(
      width: 63,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Center(
          child: Text(
            data,
            style: AppTextStyles.textTheme.headlineMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  ],
);
