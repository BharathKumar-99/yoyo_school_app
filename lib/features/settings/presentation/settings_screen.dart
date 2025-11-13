import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';

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
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "French",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Slider(
                                  value: provider.apiCred.slack.fr.toDouble(),
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  label: provider.apiCred.slack.fr
                                      .toDouble()
                                      .toStringAsFixed(0),
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
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
