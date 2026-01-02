import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

/// ------------------------------------------------------------
/// GLOBALS
/// ------------------------------------------------------------
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final SupabaseClient _client = SupabaseClientService.instance.client;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services here, call Firebase.initializeApp()
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Define Android Channel as a constant for consistency
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important school updates.',
    importance: Importance.max,
    playSound: true,
  );

  /// ------------------------------------------------------------
  /// INIT (CALL ONCE AT APP START)
  /// ------------------------------------------------------------
  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _initLocalNotifications();
    await _initFirebaseMessaging();
  }

  /// ------------------------------------------------------------
  /// LOCAL NOTIFICATION INIT
  /// ------------------------------------------------------------
  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handlePayload(response.payload);
      },
    );

    // Create the channel for Android
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }
  }

  /// ------------------------------------------------------------
  /// FCM SETUP (iOS DEBUG ENHANCED)
  /// ------------------------------------------------------------
  Future<void> _initFirebaseMessaging() async {
    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        _showDebugSnack("APNs Token: $apnsToken");
      } else {
        _showDebugSnack(
          "APNs Token is NULL. FCM will not work on this iOS device yet.",
        );
        // This usually means you need to wait a bit longer or check Xcode Signing.
      }
    }
    // 1. Request Permissions (Crucial for iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    _showDebugSnack("Permission: ${settings.authorizationStatus.name}");

    // 2. iOS APNs Token Validation
    if (Platform.isIOS) {
      // Delay allows Apple servers to register with the physical device
      await Future.delayed(const Duration(seconds: 2));
      String? apnsToken = await _firebaseMessaging.getAPNSToken();

      if (apnsToken == null) {
        _showDebugSnack(
          "ERROR: APNs Token NULL. Check Xcode & .p8 file!",
          isError: true,
        );
      } else {
        _showDebugSnack("SUCCESS: APNs Token found.");
      }
    }

    // 3. Foreground Presentation (Display banner while app is open)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 4. Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    // 5. Background -> Opened
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });

    // 6. Terminated -> Opened
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }

  /// ------------------------------------------------------------
  /// SHOW LOCAL NOTIFICATION
  /// ------------------------------------------------------------
  Future<void> showNotification(RemoteMessage message) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: message.data['route'], // Passes the route to navigation
    );
  }

  /// ------------------------------------------------------------
  /// HANDLE NOTIFICATION TAP
  /// ------------------------------------------------------------
  void handleMessage(RemoteMessage message) {
    _handlePayload(message.data['route']);
  }

  void _handlePayload(String? route) {
    if (route == null) return;

    final context = ctx;
    if (context == null) return;

    context.push(route);
  }

  /// ------------------------------------------------------------
  /// SAVE FCM TOKEN TO SUPABASE
  /// ------------------------------------------------------------
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

      devices.add({'deviceId': await _getDeviceId(), 'fcmId': fcmToken});

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
      final deviceId = await _getDeviceId();

      devices.removeWhere((element) => element['deviceId'] == deviceId);

      await _client
          .from(DbTable.users)
          .update({'fcm': devices})
          .eq('user_id', userId);
    } catch (e) {
      debugPrint("Logout Error: $e");
    }
  }

  /// ------------------------------------------------------------
  /// DEVICE ID
  /// ------------------------------------------------------------
  Future<String?> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor;
    } else if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return android.id;
    }
    return null;
  }

  /// ------------------------------------------------------------
  /// DEBUG UI HELPER
  /// ------------------------------------------------------------
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
