import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/features/home/data/home_repository.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen_provider.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'features/common/presentation/global_provider.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/profile/presentation/profile_provider.dart';
import 'l10n/app_localizations.dart';

late GlobalProvider globalProvider;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(ProfileRepository()),
        ),

        ChangeNotifierProvider.value(value: globalProvider),
        ChangeNotifierProvider(
          create: (_) => HomeScreenProvider(HomeRepository()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes.router,
        theme: AppTheme.lightTheme,
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
