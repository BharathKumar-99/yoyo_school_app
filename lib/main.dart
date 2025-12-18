import 'package:yoyo_school_app/config/utils/log_error_to_supabase.dart';
import 'package:yoyo_school_app/config/utils/shared_preferences.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/features/common/presentation/global_provider.dart';
import 'package:yoyo_school_app/features/profile/data/profile_repository.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

late final GlobalProvider globalProvider;
Future<void> main() async {
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
  FlutterError.onError = (FlutterErrorDetails details) async {
    FlutterError.presentError(details);

    final isUIError =
        details.exception is FlutterError &&
            details.exceptionAsString().contains("Render") ||
        details.exceptionAsString().contains("Layout") ||
        details.exceptionAsString().contains("paint") ||
        details.exceptionAsString().contains("overflow");

    if (isUIError) {
      return;
    }
    await logService.logError(
      error: details.exception,
      stackTrace: details.stack ?? StackTrace.empty,
      errorCode: 'FRAMEWORK_ERROR',
    );

    ctx!.push(
      RouteNames.error,
      extra: {'message': "Something Went Wrong", "error": details.stack},
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    ctx!.push(
      RouteNames.error,
      extra: {'message': "Something Went Wrong", "error": stack},
    );
    logService.logError(
      error: error,
      stackTrace: stack,
      errorCode: 'ASYNC_ERROR',
    );
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileRepository()),
        ),
        ChangeNotifierProvider.value(value: globalProvider),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,

        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        routerConfig: AppRoutes.router,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
