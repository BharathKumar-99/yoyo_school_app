import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import '../config/utils/notification_services.dart';
import '../firebase_options.dart';

class FirebaseMessagingSetup {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final firebaseMessaging = FirebaseMessaging.instance;

    await firebaseMessaging.requestPermission();

    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await NotificationService().showNotification(message);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      "high_importance_channel",
      "High Importance Notifications",
      priority: Priority.max,
      importance: Importance.max,
      icon: '@mipmap/launcher_icon',
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await NotificationService().flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "Notification",
      message.notification?.body ?? "",
      notificationDetails,
      payload: message.data.toString(),
    );
  }
}
