import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

import 'local_notification_services.dart';

class FirebaseMessagingService {
  // Private constructor for singleton pattern
  FirebaseMessagingService._internal();
  final SupabaseClient _client = SupabaseClientService.instance.client;
  // Singleton instance
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  // Factory constructor to provide singleton instance
  factory FirebaseMessagingService.instance() => _instance;

  // Reference to local notifications service for displaying notifications
  LocalNotificationsService? _localNotificationsService;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init({
    required LocalNotificationsService localNotificationsService,
  }) async {
    // Init local notifications service
    _localNotificationsService = localNotificationsService;

    // Handle FCM token

    // Request user permission for notifications
    _requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Log the user's permission decision
    print('User granted permission: ${result.authorizationStatus}');
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    print('Foreground message received: ${message.data.toString()}');
    final notificationData = message.notification;
    if (notificationData != null) {
      // Display a local notification using the service
      _localNotificationsService?.showNotification(
        notificationData.title,
        notificationData.body,
        message.data.toString(),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notification caused the app to open: ${message.data.toString()}');
    // TODO: Add navigation or specific handling based on message data
  }

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

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data.toString()}');
}
