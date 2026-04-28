import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';

class NetworkErrorScreen extends StatefulWidget {
  const NetworkErrorScreen({super.key});

  @override
  State<NetworkErrorScreen> createState() => _NetworkErrorScreenState();
}

class _NetworkErrorScreenState extends State<NetworkErrorScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNetworkCheck();
  }

  void _startNetworkCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          timer.cancel();
          if (mounted) {
            context.pop();
          }
        }
      } on SocketException catch (_) {
        // Still no internet
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 100,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 24),
              Text(
                "No Internet Connection",
                textAlign: TextAlign.center,
                style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Please check your internet connection and try again.",
                textAlign: TextAlign.center,
                style: AppTextStyles.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Retry"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
