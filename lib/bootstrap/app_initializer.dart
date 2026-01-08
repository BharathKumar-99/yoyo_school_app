import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/firebase_options.dart';

import '../app.dart';
import '../config/utils/notification_services.dart';
import '../config/utils/shared_preferences.dart';
import '../core/supabase/supabase_client.dart';
import '../features/common/presentation/global_provider.dart';
import 'error_handlers.dart';

Future<void> handlebackGroundMessaging(RemoteMessage message) async {
  NotificationService().showNotification(message);
}

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SupabaseClientService.instance.init();
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else if (Platform.isIOS) {
      await Firebase.initializeApp();
    }
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handlebackGroundMessaging);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          priority: Priority.max,
          icon: '@drawable/ic_stat_app_launcher_icon',
          color: const Color(0xFF2196F3),
          importance: Importance.max,
        ),
      );

      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
      );
      if (Platform.isAndroid) {
        await NotificationService().flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
          payload: message.data.toString(),
        );
      }
    });
    final PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }

    await SharedPrefsService.init();

    globalProvider = await GlobalProvider.create();
    ErrorHandlers.register();
    NotificationService notificationServices = NotificationService();
    notificationServices.setupInteractMessage(ctx!);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}
