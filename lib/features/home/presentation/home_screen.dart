import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/app_bar.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
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
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 120, child: getAppBar()),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(height: 10),
                      Text(
                        text.your_metrics,
                        style: AppTextStyles.textTheme.headlineLarge,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getMetricCard(text.phrases, "0"),
                          getMetricCard(text.vocab, "0"),
                          getMetricCard(text.effort, "0"),
                          getMetricCard(text.score, "0"),
                        ],
                      ),
                      SizedBox(height: 50),
                      Text(
                        text.your_classes,
                        style: AppTextStyles.textTheme.headlineLarge,
                      ),
                      SizedBox(height: 10),
                      Column(
                        children:
                            homeProvider
                                .userClases
                                ?.classes
                                ?.school
                                ?.schoolLanguage
                                ?.map(
                                  (language) => LaunguageCard(
                                    student: homeProvider.userClases,
                                    language: language,
                                    className:
                                        homeProvider
                                            .userClases
                                            ?.classes
                                            ?.className ??
                                        "",
                                  ),
                                )
                                .toList() ??
                            [],
                      ),

                      SizedBox(height: 30),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LaunguageCard extends StatelessWidget {
  final Student? student;
  final SchoolLanguage? language;
  final String className;
  const LaunguageCard({
    super.key,
    required this.language,
    required this.className,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => NavigationHelper.push(RouteNames.phrasesDetails),
          child: Hero(
            tag: language?.language?.language ?? "",
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: 151,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  gradient: LinearGradient(
                    colors: language?.language?.gradient ?? [],
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
                            image: NetworkImage(
                              language?.language?.image ?? "",
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
                            language?.language?.language ?? "",
                            style: AppTextStyles.textTheme.headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            className,
                            style: AppTextStyles.textTheme.headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            "${text.level}${language?.language?.level}",
                            style: AppTextStyles.textTheme.headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            "${student?.attemptedPhrases?.where((val) => val.phrase?.level == language?.language?.level && language?.language?.id == val.phrase?.language).length} / ${language?.language?.phrase?.length ?? 0}  ${text.phrases}",
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
        SizedBox(height: 30),
      ],
    );
  }
}

Column getMetricCard(String title, String data) => Column(
  mainAxisSize: MainAxisSize.min,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(title, style: AppTextStyles.textTheme.titleMedium),
    SizedBox(height: 10),
    Container(
      width: 63,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
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
