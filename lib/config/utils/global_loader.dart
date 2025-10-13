import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';

class GlobalLoader {
  static OverlayEntry? _loaderEntry;

  static void show() {
    if (_loaderEntry != null) return;

    final context = GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    _loaderEntry = OverlayEntry(
      builder: (context) => Container(
        color: Colors.black54,
        child: const Center(
          child: SizedBox(
            height: 80,
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );

    GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.insert(_loaderEntry!);
  }

  static void hide() {
    _loaderEntry?.remove();
    _loaderEntry = null;
  }
}
