import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/router/route_names.dart';
import '../config/router/navigation_helper.dart';
import '../config/utils/log_error_to_supabase.dart';

class ErrorHandlers {
  static void register() {
    FlutterError.onError = _handleFlutterError;
    PlatformDispatcher.instance.onError = _handleAsyncError;
  }

  static Future<void> _handleFlutterError(FlutterErrorDetails details) async {
    FlutterError.presentError(details);

    final isUIError =
        details.exceptionAsString().contains("Render") ||
        details.exceptionAsString().contains("Layout") ||
        details.exceptionAsString().contains("paint") ||
        details.exceptionAsString().contains("overflow");

    if (isUIError) return;

    await logService.logError(
      error: details.exception,
      stackTrace: details.stack ?? StackTrace.empty,
      errorCode: 'FRAMEWORK_ERROR',
    );

    ctx?.push(
      RouteNames.error,
      extra: {'message': "Something Went Wrong", 'error': details.stack},
    );
  }

  static bool _handleAsyncError(Object error, StackTrace stack) {
    logService.logError(
      error: error,
      stackTrace: stack,
      errorCode: 'ASYNC_ERROR',
    );

    ctx?.push(
      RouteNames.error,
      extra: {'message': "Something Went Wrong", 'error': stack},
    );
    return true;
  }
}
