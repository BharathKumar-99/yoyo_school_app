import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app.dart';
import '../config/utils/shared_preferences.dart';
import '../core/supabase/supabase_client.dart';
import '../features/common/presentation/global_provider.dart';
import 'error_handlers.dart';

class AppInitializer {
  static Future<void> initialize() async {
    await SupabaseClientService.instance.init();

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
