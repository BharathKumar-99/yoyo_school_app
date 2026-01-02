import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

/// ------------------------------------------------------------
/// NOTIFICATION SERVICE
/// ------------------------------------------------------------

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// ------------------------------------------------------------
  /// INIT (CALL ONCE AT APP START)
  /// ------------------------------------------------------------
  Future<void> init() async {
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

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handlePayload(response.payload);
      },
    );
  }

  /// ------------------------------------------------------------
  /// FCM SETUP
  /// ------------------------------------------------------------
  Future<void> _initFirebaseMessaging() async {
    // iOS: disable system UI in foreground (we use local notifications)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    // Foreground
    FirebaseMessaging.onMessage.listen(showNotification);

    // Background → Opened
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Terminated → Opened
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }
  }

  /// ------------------------------------------------------------
  /// SHOW LOCAL NOTIFICATION
  /// ------------------------------------------------------------
  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    final androidPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(channel);

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.high,
        priority: Priority.high,
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
      payload: message.data['route'], // IMPORTANT
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
  }

  /// ------------------------------------------------------------
  /// REMOVE FCM TOKEN (LOGOUT)
  /// ------------------------------------------------------------
  Future<void> deleteFcmFromSupabase(String userId) async {
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
}
