import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';

class GlobalLoader {
  static OverlayEntry? _loaderEntry;
  static OverlayEntry? _loaderEntryUpdate;

  static void show() {
    if (_loaderEntry != null) return;

    final context = GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    _loaderEntry = OverlayEntry(
      builder: (context) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator.adaptive(strokeWidth: 5),
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

  static void hideUpdate() {
    _loaderEntryUpdate?.remove();
    _loaderEntryUpdate = null;
  }

  static void showWidget(Widget child) {
    if (_loaderEntryUpdate != null) return;

    final context = GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    _loaderEntryUpdate = OverlayEntry(
      builder: (context) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black54,
        child: Center(child: child),
      ),
    );

    GoRouter.of(ctx!).routerDelegate.navigatorKey.currentState?.overlay?.insert(
      _loaderEntryUpdate!,
    );
  }
}
