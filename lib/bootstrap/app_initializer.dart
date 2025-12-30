import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app.dart';
import '../config/utils/shared_preferences.dart';
import '../core/supabase/supabase_client.dart';
import '../features/common/presentation/global_provider.dart';
import 'error_handlers.dart';
import 'firebase_messaging_setup.dart';

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await SupabaseClientService.instance.init();
    await SharedPrefsService.init();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );

    globalProvider = await GlobalProvider.create();

    ErrorHandlers.register();
    await FirebaseMessagingSetup.initialize();
  }
}
