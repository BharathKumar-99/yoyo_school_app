import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/core/widgets/app_bar.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/home/model/level_model.dart';
import 'package:yoyo_school_app/features/home/model/student_model.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen_provider.dart';

import '../../profile/presentation/profile_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profile, w) {
        return Consumer<HomeScreenProvider>(
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
                          if (profile.isTeacher != true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors:
                                          homeProvider
                                              .userClases
                                              ?.user
                                              ?.studentClasses
                                              ?.first
                                              .classes
                                              ?.language
                                              ?.gradient ??
                                          [],
                                    ),
                                  ),
                                  child: Text(
                                    "🔔 Homework ${homeProvider.homeworkDays > 0 ? 'due in' : 'overdue by'} ${homeProvider.homeworkDays.abs()} days! ",
                                    textAlign: TextAlign.center,
                                    style: TextTheme.of(context).titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
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
                                      homeProvider.student?.vocab.toString() ??
                                          "0",
                                      (homeProvider.student?.vocab ?? 0) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.effort,
                                      "${homeProvider.student?.effort.toString() ?? "0"}% ",
                                      (homeProvider.student?.effort ?? 0) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.score,
                                      "${homeProvider.student?.score.toString() ?? "0"}%",
                                      (homeProvider.student?.score ?? 0) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(height: 30),
                          _AnimatedSectionTitle(text.your_classes),
                          const SizedBox(height: 20),
                          Column(
                            children:
                                homeProvider.userClases?.user?.studentClasses
                                    ?.asMap()
                                    .entries
                                    .map(
                                      (entry) => _AnimatedCard(
                                        delay: 300 * entry.key,
                                        child: LaunguageCard(
                                          student: homeProvider.userClases,
                                          language:
                                              entry.value.classes?.language,
                                          level: homeProvider.levels ?? [],
                                          className:
                                              entry.value.classes?.className ??
                                              "",
                                        ),
                                      ),
                                    )
                                    .toList() ??
                                [],
                          ),
                          if (profile.isTeacher != true)
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Leader board',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Rank#${homeProvider.userDetailsModel.where((val) => val.userId == homeProvider.profileProvider?.user?.userId).isEmpty ? "0" : homeProvider.userDetailsModel.where((val) => val.userId == homeProvider.profileProvider?.user?.userId).toList().first.classRank}',
                                        style: TextTheme.of(context).titleSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "Username",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "Effort",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            "Score",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...homeProvider.userDetailsModel.map(
                                      (e) => TableRow(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "${e.classRank == 1 ? "🥇" : ""} ${e.username ?? ""}",
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight:
                                                        e.classRank == 1 ||
                                                            e.userId ==
                                                                homeProvider
                                                                    .profileProvider
                                                                    ?.user
                                                                    ?.userId
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: e.classRank == 1
                                                        ? Colors.grey[800]
                                                        : e.userId ==
                                                              homeProvider
                                                                  .profileProvider
                                                                  ?.user
                                                                  ?.userId
                                                        ? homeProvider
                                                                  .userClases
                                                                  ?.user
                                                                  ?.studentClasses
                                                                  ?.first
                                                                  .classes
                                                                  ?.language
                                                                  ?.gradient
                                                                  ?.first ??
                                                              Colors.black
                                                        : Colors.black,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              "${e.effort}%",
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight:
                                                        e.classRank == 1 ||
                                                            e.userId ==
                                                                homeProvider
                                                                    .profileProvider
                                                                    ?.user
                                                                    ?.userId
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: e.classRank == 1
                                                        ? Colors.grey[800]
                                                        : e.userId ==
                                                              homeProvider
                                                                  .profileProvider
                                                                  ?.user
                                                                  ?.userId
                                                        ? homeProvider
                                                                  .userClases
                                                                  ?.user
                                                                  ?.studentClasses
                                                                  ?.first
                                                                  .classes
                                                                  ?.language
                                                                  ?.gradient
                                                                  ?.first ??
                                                              Colors.black
                                                        : Colors.black,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              '${e.score}%',
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight:
                                                        e.classRank == 1 ||
                                                            e.userId ==
                                                                homeProvider
                                                                    .profileProvider
                                                                    ?.user
                                                                    ?.userId
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: e.classRank == 1
                                                        ? Colors.grey[800]
                                                        : e.userId ==
                                                              homeProvider
                                                                  .profileProvider
                                                                  ?.user
                                                                  ?.userId
                                                        ? homeProvider
                                                                  .userClases
                                                                  ?.user
                                                                  ?.studentClasses
                                                                  ?.first
                                                                  .classes
                                                                  ?.language
                                                                  ?.gradient
                                                                  ?.first ??
                                                              Colors.black
                                                        : Colors.black,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (profile.isTeacher == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _AnimatedSectionTitle(text.class_metrics),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors:
                                              homeProvider
                                                  .userClases
                                                  ?.user
                                                  ?.studentClasses
                                                  ?.first
                                                  .classes
                                                  ?.language
                                                  ?.gradient ??
                                              [],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Rank#${homeProvider.userDetailsModel.where((val) => val.userId == homeProvider.profileProvider?.user?.userId).isEmpty ? "0" : homeProvider.userDetailsModel.where((val) => val.userId == homeProvider.profileProvider?.user?.userId).toList().first.classRank}',
                                        style: TextTheme.of(context).titleSmall!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                _AnimatedRow(
                                  delay: 200,
                                  children: [
                                    getMetricCard(
                                      text.phrases,
                                      "${homeProvider.classCPhrases}/${homeProvider.classPhrases}",
                                      (homeProvider.classCPhrases) >
                                              (homeProvider.classPhrases / 2)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.vocab,
                                      homeProvider.classVocab.toString(),
                                      (homeProvider.classVocab) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.effort,
                                      "${homeProvider.classEffort}% ",
                                      (homeProvider.classEffort) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.score,
                                      "${homeProvider.classScore}%",
                                      (homeProvider.classScore) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                _AnimatedSectionTitle(text.school_metrics),
                                _AnimatedRow(
                                  delay: 200,
                                  children: [
                                    getMetricCard(
                                      text.phrases,
                                      "${homeProvider.schoolCPhrase}/${homeProvider.schoolPhrase}",
                                      (homeProvider.schoolCPhrase) >
                                              (homeProvider.schoolPhrase / 2)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.vocab,
                                      homeProvider.schoolVocab.toString(),
                                      (homeProvider.schoolVocab) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.effort,
                                      "${homeProvider.schoolEffort}% ",
                                      (homeProvider.schoolEffort) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.score,
                                      "${homeProvider.schoolScore}%",
                                      (homeProvider.schoolScore) >
                                              (homeProvider
                                                      .globalProvider
                                                      ?.apiCred
                                                      ?.successThreshold ??
                                                  0)
                                          ? Colors.green.shade700
                                          : Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                _AnimatedSectionTitle(text.homework),
                                SizedBox(height: 15),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.push(RouteNames.addHomeWork);
                                    },
                                    child: Text(text.set_homework),
                                  ),
                                ),
                                SizedBox(height: 15),
                                _AnimatedRow(
                                  delay: 200,
                                  children: [
                                    getMetricCard(
                                      text.set,
                                      homeProvider.homeWorkModel.isNotEmpty
                                          ? formatDate(
                                              homeProvider
                                                  .homeWorkModel
                                                  .last
                                                  .setDate!,
                                            )
                                          : "N/A",
                                      Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.due,
                                      homeProvider.homeWorkModel.isNotEmpty
                                          ? formatDate(
                                              homeProvider
                                                  .homeWorkModel
                                                  .last
                                                  .setDate!,
                                            )
                                          : "N/A",
                                      Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.students,
                                      "${homeProvider.homeworkCompletedStudents}/${homeProvider.homeworkStudent}",
                                      Colors.orangeAccent,
                                    ),
                                    getMetricCard(
                                      text.score,
                                      "${homeProvider.homeWorkScore}%",
                                      Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

String formatDate(DateTime date) {
  return DateFormat('dd/MM').format(date);
}

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

class _AnimatedRow extends StatelessWidget {
  final List<Widget> children;
  final int delay;
  const _AnimatedRow({required this.children, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.2, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        );
      },
    );
  }
}

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
  final Language? language;
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
          onTap: () => NavigationHelper.go(
            RouteNames.phraseCategories,
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
              tag: widget.language?.language ?? "",
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
                      colors: widget.language?.gradient ?? [],
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
                                widget.language?.image ?? "",
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
                              widget.language?.language ?? "",
                              style: AppTextStyles.textTheme.headlineSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              widget.className,
                              style: AppTextStyles.textTheme.headlineSmall!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              "${text.level}${UsefullFunctions.returnLevel(widget.language?.level ?? 0, widget.level)}",
                              style: AppTextStyles.textTheme.headlineSmall!
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

Widget getMetricCard(String title, String data, Color bgColor) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(title, style: AppTextStyles.textTheme.titleMedium),
          const SizedBox(height: 10),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: bgColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Center(
                child: AutoSizeText(
                  data,
                  maxLines: 1,
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
