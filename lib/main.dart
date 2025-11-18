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
import 'core/supabase/supabase_client.dart';
import 'package:rive/rive.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientService.instance.init();
  unawaited(RiveFile.initialize());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
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
        ChangeNotifierProvider(create: (_) => GlobalProvider()),
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
