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
                        ListTile(
                          title: Text(
                            text.frenchSlack,
                            style: AppTextStyles.textTheme.titleLarge,
                          ),
                          subtitle: TextField(
                            controller: provider.frenchSlackController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*$'),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => provider.updateFrenchSlack(),
                            child: Text('Update'),
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
