import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_tracker.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/auth/presentation/login_screen.dart';
import 'package:yoyo_school_app/features/auth/presentation/otp_screen.dart';
import 'package:yoyo_school_app/features/auth/presentation/request_activation_screen.dart';
import 'package:yoyo_school_app/features/common/presentation/app_update_screen.dart';
import 'package:yoyo_school_app/features/common/presentation/maintainance_mode.dart';
import 'package:yoyo_school_app/features/errors/presentation/error_scren.dart';
import 'package:yoyo_school_app/features/home/model/phrases_model.dart';
import 'package:yoyo_school_app/features/home/presentation/home_screen.dart';
import 'package:yoyo_school_app/features/listen_and_type/presentation/listen_and_type_screen.dart';
import 'package:yoyo_school_app/features/listen_and_type_result/presentation/listen_and_type_result_screen.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_provider.dart';
import 'package:yoyo_school_app/features/master_phrase/presentation/master_phrase_sreen.dart';
import 'package:yoyo_school_app/features/onboarding_screen/presentation/onboarding_screen.dart';
import 'package:yoyo_school_app/features/permission_screen/presentation/permission_screen.dart';
import 'package:yoyo_school_app/features/phrases/presentation/phrase_categories.dart';
import 'package:yoyo_school_app/features/phrases/presentation/phrases_details.dart';
import 'package:yoyo_school_app/features/profile/presentation/your_profile_screen.dart';
import 'package:yoyo_school_app/features/master_result/presentation/master_result_screen.dart';
import 'package:yoyo_school_app/features/recording/presentation/remember_recorder_provider.dart';
import 'package:yoyo_school_app/features/result/presentation/result_screen.dart';
import 'package:yoyo_school_app/features/splash/presentation/splash_screen.dart';
import 'package:yoyo_school_app/features/try_phrases/presentation/try_phrases_provider.dart';
import 'package:yoyo_school_app/features/webview/presentation/webview_screen.dart';

import '../../features/listen_and_type/presentation/listen_and_type_view_model.dart';
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
        path: RouteNames.appUpdate,
        builder: (context, state) => const AppUpdateScreen(),
      ),
      GoRoute(
        path: RouteNames.permission,
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: RouteNames.appMaintenance,
        builder: (context, state) => const MaintenanceModeScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.needActivationCode,
        builder: (context, state) => const RequestActivationScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) => OtpScreen(userName: state.extra as String),
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
        path: RouteNames.webview,
        builder: (context, state) => WebViewScreen(url: state.extra as String),
      ),

      GoRoute(
        path: RouteNames.error,
        builder: (context, state) {
          Map data = state.extra as Map;
          return ErrorScreen(message: data['message'], error: data['error']);
        },
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
            categories: data['categories'],
          );
        },
      ),

      GoRoute(
        path: RouteNames.phraseCategories,
        builder: (context, state) {
          Map data = state.extra as Map;
          return PhraseCategories(
            language: data['language'],
            className: data['className'],
            levels: data['level'],
            student: data['student'],
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
            categories: data['categories'],
            className: data['className'],
          );
        },
      ),
      GoRoute(
        path: RouteNames.listenAndTypeScreenResult,
        builder: (context, state) {
          Map data = state.extra as Map;
          return ListenAndTypeResultScreen(
            model: data['phraseModel'],
            typedString: data['typedPhrase'],
            language: data['language'],
            categories: data['categories'],
            className: data['className'],
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
            categories: data['categories'],
            className: data['className'],
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
              data['categories'],
              context,
            ),
            child: ChangeNotifierProvider<RecordingProvider>(
              create: (context) => RecordingProvider(
                data['phrase'] as PhraseModel,
                data['language'],
                data['streak'],
                data['isLast'],
                data['categories'],
                data['className'],
              ),
              child: TryPhrasesScreen(
                key: UniqueKey(),
                phraseModel: data['phrase'] as PhraseModel,
                streak: data['streak'],
                language: data['language'],
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
            create: (_) => MasterPhraseProvider(
              data['phrase'] as PhraseModel,
              data['categories'],
            ),
            child: ChangeNotifierProvider<RememberRecorderProvider>(
              create: (_) => RememberRecorderProvider(
                data['phrase'] as PhraseModel,
                data['language'],
                data['streak'],
                data['isLast'],
                data['categories'],
                data['className'],
              ),
              child: MasterPhraseSreen(
                key: UniqueKey(),
                model: data['phrase'] as PhraseModel,
                streak: data['streak'],
                language: data['language'],
                className: data['className'],
                student: data['student'],
                isLast: data['isLast'],
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.listenAndTypeScreen,
        builder: (context, state) {
          Map data = state.extra as Map;
          return ChangeNotifierProvider<ListenAndTypeViewModel>(
            create: (context) => ListenAndTypeViewModel(
              data['phrase'] as PhraseModel,
              data['categories'],
              data['language'],
              data['className'],
            ),
            child: ListenAndTypeScreen(
              key: UniqueKey(),
              model: data['phrase'] as PhraseModel,
              categories: data['categories'],
              language: data['language'],
              className: data['className'],
              student: data['student'],
            ),
          );
        },
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => YourProfile(),
      ),
    ],
    observers: [routeTracker],
    redirect: (context, state) async {
      final supabase = SupabaseClientService.instance.client;
      final isAuthenticated =
          supabase.auth.currentSession != null ||
          GetUserDetails.getCurrentUserId() != null;

      final goingToLogin = state.fullPath == RouteNames.login;
      final goingToActivationCode =
          state.fullPath == RouteNames.needActivationCode;

      final permissionsGranted = await allGranted();

      if (!permissionsGranted) {
        return RouteNames.permission;
      }

      if (isAuthenticated && goingToLogin) {
        return RouteNames.splash;
      }

      if (!isAuthenticated && !goingToLogin && !goingToActivationCode) {
        return RouteNames.login;
      }

      return null;
    },
  );

  static Future<dynamic> allGranted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.kMicGrantedKey) ?? false;
  }
}
