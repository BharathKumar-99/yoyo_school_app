import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import '../router/navigation_helper.dart';
import 'device_info.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final SupabaseClient _client = SupabaseClientService.instance.client;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(message) async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
          '@drawable/ic_stat_app_launcher_icon',
        );
    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(message);
      },
    );
  }

  void handleMessage(message) {}

  Future<void> setupInteractMessage(BuildContext context) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });
  }

  Future<void> showNotification(message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: 'your channel description',
          importance: Importance.high,
          icon: '@drawable/ic_stat_app_launcher_icon',
          color: const Color(0xFF2196F3),
          priority: Priority.high,
          ticker: 'ticker',
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        message.notification!.hashCode,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  DeviceInformation deviceInformation = DeviceInformation();
  Future<void> saveFcmToSupabase(String fcmToken, String userId) async {
    try {
      final response = await _client
          .from(DbTable.users)
          .select('fcm')
          .eq('user_id', userId)
          .single();

      final List<dynamic> devices = response['fcm'] ?? [];
      final existingTokens = devices.map((e) => e['fcmId']).toList();

      if (existingTokens.contains(fcmToken)) return;

      devices.add({'deviceId': await _getId(), 'fcmId': fcmToken});

      await _client
          .from(DbTable.users)
          .update({'fcm': devices})
          .eq('user_id', userId);

      _showDebugSnack("FCM saved to Supabase");
    } catch (e) {
      _showDebugSnack("Supabase Error: $e", isError: true);
    }
  }

  /// ------------------------------------------------------------
  /// REMOVE FCM TOKEN (LOGOUT)
  /// ------------------------------------------------------------
  Future<void> deleteFcmFromSupabase(String userId) async {
    try {
      final response = await _client
          .from(DbTable.users)
          .select('fcm')
          .eq('user_id', userId)
          .single();

      final List<dynamic> devices = response['fcm'] ?? [];
      final deviceId = await _getId();

      devices.removeWhere((element) => element['deviceId'] == deviceId);

      await _client
          .from(DbTable.users)
          .update({'fcm': devices})
          .eq('user_id', userId);
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }

  Future<String?> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }

  void _showDebugSnack(String message, {bool isError = false}) {
    final context = ctx;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.blueGrey,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
