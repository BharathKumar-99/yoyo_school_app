import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/result/model/remote_config_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(text.settings)),
      body: Consumer<GlobalProvider>(
        builder: (context, provider, a) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            text.enableStreak,
                            style: AppTextStyles.textTheme.titleLarge,
                          ),
                          trailing: Switch.adaptive(
                            value: provider.apiCred.streak,
                            onChanged: (val) {
                              provider.updateStreakEnabled(val);
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "French",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.fr.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.fr
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.fr = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Russian",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.ru.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.ru
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.ru = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Spanish",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.sp.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.sp
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.sp = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "German",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.de.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.de
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.de = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Korean",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.kr.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.kr
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.kr = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mandarin",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.promaxCn.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.promaxCn
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.promaxCn = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Japanese",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.jp.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.jp
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.jp = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "English",
                              style: AppTextStyles.textTheme.titleLarge,
                            ),
                            Slider(
                              value: provider.apiCred.slack.promax.toDouble(),
                              min: 0,
                              max: 100,
                              divisions: 10,
                              label: provider.apiCred.slack.promax
                                  .toDouble()
                                  .toStringAsFixed(0),
                              onChanged: (value) {
                                LanguageSlack slack = provider.apiCred.slack;
                                slack.promax = value;
                                provider.updateSlack(slack);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      "V${provider.version}",
                      style: AppTextStyles.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey,
                      ),
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
