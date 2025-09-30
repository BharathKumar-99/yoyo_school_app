import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/l10n/app_localizations.dart';
import 'app_router.dart';

BuildContext? get ctx => AppRoutes.navigatorKey.currentContext;

AppLocalizations get text {
  if (ctx == null) {
    throw Exception(
      'NavigationHelper context is null. Make sure navigatorKey is initialized.',
    );
  }
  return AppLocalizations.of(ctx!)!;
}

class NavigationHelper {
  static BuildContext? get context => AppRoutes.navigatorKey.currentContext;

  static void go(String route, {Object? extra}) {
    if (context != null) {
      context!.go(route, extra: extra);
    }
  }

  static void push(String route, {Object? extra}) {
    if (context != null) {
      context!.push(route, extra: extra);
    }
  }

  static void pop<T extends Object?>([T? result]) {
    if (context != null && Navigator.canPop(context!)) {
      Navigator.pop(context!, result);
    }
  }
}
