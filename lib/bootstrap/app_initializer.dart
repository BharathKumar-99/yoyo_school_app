import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyo_school_app/bootstrap/notification_services.dart';
import 'package:yoyo_school_app/features/permission_screen/presentation/permission_screen.dart'
    as Constants;
import 'package:yoyo_school_app/firebase_options.dart';
import '../app.dart';
import '../config/utils/shared_preferences.dart';
import '../core/supabase/supabase_client.dart';
import '../features/common/presentation/global_provider.dart';
import 'error_handlers.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    // 2. Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 3. Set background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await SupabaseClientService.instance.init();
    handleNotification();
    await SharedPrefsService.init();

    globalProvider = await GlobalProvider.create();
    ErrorHandlers.register();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }
}

void handleNotification() async {
  final prefs = await SharedPreferences.getInstance();
  final notificationGranted =
      prefs.getBool(Constants.kNotificationGrantedKey) ?? false;

  if (notificationGranted) {
    await NotificationServices().initializeFCM();
  }
}
