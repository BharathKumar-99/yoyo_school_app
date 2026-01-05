import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key});

  // Placeholder function for launching the store URL.
  // In a real app, this would use the 'url_launcher' package.
  void _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Handle error, e.g., show a dialog
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
    print('Attempting to launch URL: $url');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 2,
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: Card(
            elevation: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Icon for Update
                Icon(
                  Icons.system_update_alt,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  text.new_version_available,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  text.app_update_subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Button Row for Store Links
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (Platform.isAndroid)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _launchUrl(UrlConstants.playStoreUrl),
                          icon: const Icon(Icons.shop),
                          label: const Text('Play Store'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),

                    //if (Platform.isIOS)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchUrl(UrlConstants.appStoreUrl),
                        icon: const Icon(Icons.apple),
                        label: const Text('App Store'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Positioned(
          right: 1,
          child: CircleAvatar(
            child: IconButton(
              onPressed: () {
                GlobalLoader.hideUpdate();
              },
              icon: Icon(Icons.close),
            ),
          ),
        ),
      ],
    );
  }
}
