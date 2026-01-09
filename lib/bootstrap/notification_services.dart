import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

class NotificationServices {
  final SupabaseClient _client = SupabaseClientService.instance.client;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 3. Request Permissions (Crucial for iOS/TestFlight)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // 5. Setup Local Notifications (For Foreground Alerts)
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    // 6. Listen for Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
          message.notification!.title,
          message.notification!.body,
        );
      }
    });
  }

  Future<void> saveFcmToFireBase(String userId) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();
    final response = await _client
        .from(DbTable.users)
        .select('fcm')
        .eq('user_id', userId)
        .single();

    final Map<String, dynamic> userData = response;
    List<dynamic> deviceIds = userData['fcm_tokens'] ?? [];
    List<dynamic> ids = [];
    for (var i = 0; i < deviceIds.length; i++) {
      ids.add(deviceIds[i]['fcm_tokens']);
    }
    if (ids.contains(fcmToken)) {
      return;
    }
    deviceIds.add({'deviceId': await _getId(), 'fcmId': fcmToken});
    await _client
        .from(DbTable.users)
        .update({'fcm': deviceIds})
        .eq('user_id', userId);
  }

  // 7. Show the actual notification popup
  Future<void> _showNotification(String? title, String? body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_channel',
        'Urgent',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );
    await _localNotifications.show(0, title, body, details);
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
}
