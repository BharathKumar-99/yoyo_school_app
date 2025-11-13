import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/auth/presentation/login_screen.dart';
import 'package:yoyo_school_app/features/auth/presentation/otp_screen.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_provider.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_sreen.dart';
import 'package:yoyo_school_app/features/onboarding_screen/presentation/onboarding_screen.dart';
import 'package:yoyo_school_app/features/phrases/presentation/phrases_details.dart';
import 'package:yoyo_school_app/features/profile/presentation/your_profile_screen.dart';
import 'package:yoyo_school_app/features/master_result/presentation/master_result_screen.dart';
import 'package:yoyo_school_app/features/recording/presentation/remember_recorder_provider.dart';
import 'package:yoyo_school_app/features/result/presentation/result_screen.dart';
import 'package:yoyo_school_app/features/settings/presentation/settings_screen.dart';
import 'package:yoyo_school_app/features/splash/presentation/splash_screen.dart';
import 'package:yoyo_school_app/features/try_phrases/presentation/try_phrases_provider.dart';

import '../../features/recording/presentation/recorder_provider.dart';
import '../../features/try_phrases/presentation/try_phrases_screen.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.splash,
    initialExtra: true,
    debugLogDiagnostics: false,

    routes: [
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) => OtpScreen(email: state.extra as String),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.phrasesDetails,
        builder: (context, state) {
          Map data = state.extra as Map;
          return PhrasesDetails(
            key: UniqueKey(),
            language: data['language'],
            className: data['className'],
            levels: data['level'],
            student: data['student'],
            next: data['next'],
            streak: data['streak'],
            from: data['from'],
            streakPhraseId: data['phraseId'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.result,
        builder: (context, state) {
          Map data = state.extra as Map;
          return ResultScreen(
            phraseModel: data['phraseModel'],
            language: data['language'],
            audioPath: data['path'],
            isLast: data['isLast'],
            retryNumber: data['retry'] ?? 0,
          );
        },
      ),
      GoRoute(
        path: RouteNames.masterResult,
        builder: (context, state) {
          Map data = state.extra as Map;
          return MasterResultScreen(
            phraseModel: data['phraseModel'],
            language: data['language'],
            audioPath: data['path'],
            isLast: data['isLast'],
            retryNumber: data['retry'] ?? 0,
          );
        },
      ),

      GoRoute(
        path: RouteNames.tryPhrases,
        builder: (context, state) {
          Map data = state.extra as Map;
          return ChangeNotifierProvider<TryPhrasesProvider>(
            create: (context) => TryPhrasesProvider(
              data['phrase'] as PhraseModel,
              data['streak'],
              data['isLast'],
            ),
            child: ChangeNotifierProvider<RecordingProvider>(
              create: (context) => RecordingProvider(
                data['phrase'] as PhraseModel,
                data['language'],
                data['streak'],
                data['isLast'],
              ),
              child: TryPhrasesScreen(
                key: UniqueKey(),
                phraseModel: data['phrase'] as PhraseModel,
                streak: data['streak'],
                schoolLanguage: data['schoolLanguage'],
                className: data['className'],
                student: data['student'],
                isLast: data['isLast'],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.masterPhrases,
        builder: (context, state) {
          Map data = state.extra as Map;
          return ChangeNotifierProvider<MasterPhraseProvider>(
            create: (_) => MasterPhraseProvider(data['phrase'] as PhraseModel),
            child: ChangeNotifierProvider<RememberRecorderProvider>(
              create: (_) => RememberRecorderProvider(
                data['phrase'] as PhraseModel,
                data['language'],
                data['streak'],
                data['isLast'],
              ),
              child: MasterPhraseSreen(
                key: UniqueKey(),
                model: data['phrase'] as PhraseModel,
                streak: data['streak'],
                schoolLanguage: data['schoolLanguage'],
                className: data['className'],
                student: data['student'],
                isLast: data['isLast'],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) =>
            YourProfile(isFromOtp: state.extra as bool? ?? false),
      ),
    ],
    redirect: (context, state) {
      final supabase = SupabaseClientService.instance.client;
      final currentUser = supabase.auth.currentUser;
      final goingToLogin = state.fullPath == RouteNames.login;
      final goingToOtp = state.fullPath == RouteNames.otp;
      if (supabase.auth.currentSession == null &&
          currentUser == null &&
          !goingToLogin &&
          !goingToOtp) {
        return RouteNames.login;
      }
      if (currentUser != null && goingToLogin) {
        return RouteNames.splash;
      }
      return null;
    },
  );
}
