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
      print(
        '🔔 [FCM] Foreground Message Received: ${message.notification?.title}',
      );

      if (message.notification != null) {
        _showNotification(
          message.notification!.title,
          message.notification!.body,
        );
      }
    });

    // 7. Listen for Token Refresh
    // This is crucial because Firebase rotates tokens periodically.
    // We must update our Supabase DB whenever this happens to ensure notifications still arrive.
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print('🔄 [FCM] Token refreshed: ${newToken.substring(0, 20)}...');

      final user = _client.auth.currentSession?.user;
      // CRITICAL: We use 'user_id' from metadata because Auth ID != Database ID in this custom login system.
      // The 'users' table uses a custom ID that is stored in the Auth user's metadata.
      final dbUserId = user?.userMetadata?['user_id'] as String?;

      if (dbUserId != null) {
        print('🔄 [FCM] Updating token for DB User ID: $dbUserId');
        await saveFcmToFireBase(dbUserId);
      } else {
        print(
          '⚠️ [FCM] Token refreshed but no mapped "user_id" found in metadata',
        );
      }
    });

    // 8. Check Token on Startup if Logged In
    final user = _client.auth.currentSession?.user;
    // CRITICAL: Must use metadata 'user_id' to match 'users' table primary key.
    final dbUserId = user?.userMetadata?['user_id'] as String?;

    if (dbUserId != null) {
      print('📱 [FCM] Startup: Validating token for DB User ID: $dbUserId');
      saveFcmToFireBase(dbUserId);
    } else {
      print(
        '⚠️ [FCM] Startup: User logged in but no "user_id" in metadata via Auth.',
      );
    }
  }

  Future<void> saveFcmToFireBase(String userId) async {
    print('📱 [FCM] Starting token registration for Auth User ID: $userId');
    // Note: We are querying the 'users' table using this ID.
    // If auth.uid != table.user_id, this will fail.

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final fcmToken = await messaging.getToken();

    print('📱 [FCM] Retrieved FCM token: ${fcmToken?.substring(0, 20)}...');

    if (fcmToken == null) {
      print('❌ [FCM] FCM token is null, skipping registration');
      return;
    }

    final response = await _client
        .from(DbTable.users)
        // FIXED: Renamed column from 'fcm_tokens' to 'fcm' to match database schema.
        .select('fcm')
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      print('❌ [FCM] User record not found in database for ID: $userId');
      return;
    }

    final Map<String, dynamic> userData = response;
    // We store tokens as a list of objects: [{'deviceId': '...', 'fcmId': '...'}]
    // This allows a single user to receive notifications on multiple devices (iPad + iPhone).
    List<dynamic> deviceIds = userData['fcm'] ?? [];

    print('📱 [FCM] Existing tokens in database: ${deviceIds.length}');

    List<dynamic> ids = [];
    for (var i = 0; i < deviceIds.length; i++) {
      // We check 'fcmId' (the token) to prevent duplicates
      ids.add(deviceIds[i]['fcmId']);
    }

    if (ids.contains(fcmToken)) {
      print(
        '✅ [FCM] Current token is fresh and already in DB. Skipping update.',
      );
      return;
    }

    final deviceId = await _getId();
    print('📱 [FCM] Device ID: $deviceId');

    deviceIds.add({'deviceId': deviceId, 'fcmId': fcmToken});

    await _client
        .from(DbTable.users)
        .update({'fcm': deviceIds})
        .eq('user_id', userId);

    print(
      '✅ [FCM] Successfully registered new token. Total tokens: ${deviceIds.length}',
    );
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
