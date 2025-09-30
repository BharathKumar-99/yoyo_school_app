import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/core/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              SizedBox(height: 10),
              Text(
                text.your_metrics,
                style: AppTextStyles.textTheme.headlineLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getMetricCard(text.phrases, "0"),
                  getMetricCard(text.vocab, "0"),
                  getMetricCard(text.effort, "0"),
                  getMetricCard(text.score, "0"),
                ],
              ),
              SizedBox(height: 15),
              Text(
                text.your_classes,
                style: AppTextStyles.textTheme.headlineLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Column getMetricCard(String title, String data) => Column(
  spacing: 10,
  children: [
    Text(title, style: AppTextStyles.textTheme.titleMedium),
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
