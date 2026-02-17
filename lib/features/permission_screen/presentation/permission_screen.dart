import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyo_school_app/bootstrap/notification_services.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';

const String kMicGrantedKey = Constants.kMicGrantedKey;
const String kNotificationGrantedKey = Constants.kNotificationGrantedKey;

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  bool micGranted = false;
  bool notificationGranted = false;
  bool loading = false;

  late final RecorderController _recorderController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100
      ..bitRate = 128000;

    _loadPermissionStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recorderController.dispose();
    super.dispose();
  }

  /// 🔄 Recheck when returning from Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadPermissionStatus();
    }
  }

  /// 🔐 Load from SharedPreferences (UI source)
  Future<void> _loadPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      micGranted = prefs.getBool(kMicGrantedKey) ?? false;
      notificationGranted = prefs.getBool(kNotificationGrantedKey) ?? false;
    });
  }

  /// 🎤 Request mic by actual recording (best for iOS)
  Future<void> _requestMicByRecording() async {
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/mic_probe.aac';

      await _recorderController.record(path: path);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kMicGrantedKey, true);

      setState(() {
        micGranted = true;
      });

      await Future.delayed(const Duration(seconds: 1));
      await _recorderController.stop();

      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Mic probe failed: $e');
    }
  }

  Future<void> _handleMicTap() async {
    setState(() => loading = true);

    await _requestMicByRecording();

    final status = await Permission.microphone.status;
    if (status.isPermanentlyDenied || status.isRestricted) {
      await openAppSettings();
    }

    await _loadPermissionStatus();

    setState(() => loading = false);
  }

  /// 🔔 Notification Permission
  Future<void> _handleNotificationTap() async {
    setState(() => loading = true);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(kNotificationGrantedKey, true);
      await NotificationServices().initializeFCM();
    }

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await openAppSettings();
    }

    await _loadPermissionStatus();

    setState(() => loading = false);
  }

  bool get allGranted => micGranted && notificationGranted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              const Text(
                "Permissions",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "We need some permissions to move forward",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),

              _PermissionTile(
                icon: Icons.notifications,
                title: "Notification",
                description: "Used for reminders and important updates",
                granted: notificationGranted,
                onTap: _handleNotificationTap,
              ),

              const SizedBox(height: 20),

              _PermissionTile(
                icon: Icons.mic,
                title: "Microphone",
                description: "Used for recording phrases",
                granted: micGranted,
                onTap: _handleMicTap,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allGranted
                        ? Colors.blue
                        : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: allGranted
                      ? () => context.go(RouteNames.splash)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              /// Invisible waveform keeps recorder stable on iOS
              AudioWaveforms(
                recorderController: _recorderController,
                size: const Size(0, 0),
                waveStyle: const WaveStyle(showMiddleLine: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool granted;
  final VoidCallback onTap;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.granted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: granted ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: granted ? Colors.green.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: granted ? Colors.green : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: granted ? Colors.green : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: granted ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              granted ? Icons.check_circle : Icons.arrow_forward_ios,
              color: granted ? Colors.green : Colors.grey,
              size: granted ? 28 : 18,
            ),
          ],
        ),
      ),
    );
  }
}
