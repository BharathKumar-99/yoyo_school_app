import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/auth/presentation/login_screen.dart';
import 'package:yoyo_school_app/features/auth/presentation/otp_screen.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_sreen.dart';
import 'package:yoyo_school_app/features/phrases/presentation/phrases_details.dart';
import 'package:yoyo_school_app/features/profile/presentation/your_profile_screen.dart';
import 'package:yoyo_school_app/features/master_result/presentation/master_result_screen.dart';
import 'package:yoyo_school_app/features/result/presentation/result_screen.dart';

import '../../features/try_phrases/presentation/try_phrases_screen.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.home,
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
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.phrasesDetails,
        builder: (context, state) {
          Map data = state.extra as Map;
          return PhrasesDetails(
            language: data['language'],
            className: data['className'],
            levels: data['level'],
            student: data['student'],
            next: data['next'],
            streak: data['streak'],
            from: data['from'],
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
          );
        },
      ),

      GoRoute(
        path: RouteNames.tryPhrases,
        builder: (context, state) {
          Map data = state.extra as Map;
          return TryPhrasesScreen(
            phraseModel: data['phrase'] as PhraseModel,
            streak: data['streak'],
            schoolLanguage: data['schoolLanguage'],
            className: data['className'],
            student: data['student'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.masterPhrases,
        builder: (context, state) {
          Map data = state.extra as Map;
          return MasterPhraseSreen(
            model: data['phrase'] as PhraseModel,
            streak: data['streak'],
            schoolLanguage: data['schoolLanguage'],
            className: data['className'],
            student: data['student'],
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
        return RouteNames.home;
      }
      return null;
    },
  );
}
