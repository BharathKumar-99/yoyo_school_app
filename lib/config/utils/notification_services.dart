import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

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
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        if (payload.payload?.startsWith('error:') == true) {
          ctx!.push(RouteNames.error, extra: payload.payload);
        }
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
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: "assets/appicon.png",
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

  Future<void> saveFcmToFireBase(String fcmToken, String userId) async {
    final response = await _client
        .from(DbTable.users)
        .select('fcm')
        .eq('user_id', userId)
        .single();

    final Map<String, dynamic> userData = response;
    List<dynamic> deviceIds = userData['fcm'] ?? [];
    List<dynamic> ids = [];
    for (var i = 0; i < deviceIds.length; i++) {
      ids.add(deviceIds[i]['fcm']);
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

  deleteFcmFromSupabse(String userId) async {
    final response = await _client
        .from(DbTable.users)
        .select('fcm')
        .eq('user_id', userId)
        .single();

    final Map<String, dynamic> userData = response;
    List<dynamic> deviceIds = userData['fcm'] ?? [];
    List<dynamic> ids = [];
    for (int i = 0; i < deviceIds.length; i++) {
      ids.add(deviceIds[i]['deviceId']);
    }
    String? deviceId = await _getId();
    deviceIds.removeWhere((element) => element['deviceId'] == deviceId);
    await _client
        .from(DbTable.users)
        .update({'fcm': deviceIds})
        .eq('user_id', userId);
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
