import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/utils/notification_services.dart';

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
  NotificationService notificationServices = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationServices.setupInteractMessage(context);
  }

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
