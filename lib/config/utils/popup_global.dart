import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:intl/intl.dart';
import '../../features/home/model/language_model.dart';
import '../../features/home/model/level_model.dart';
import '../../features/home/model/student_model.dart';
import '../constants/constants.dart';
import '../router/route_names.dart';

class PopupDialog {
  static OverlayEntry? _loaderEntry;
  static OverlayEntry? _loaderEntryUpdate;

  static String formatDate(DateTime date) {
    return DateFormat('dd-MM-yy').format(date);
  }

  static void show(
    DateTime time,
    Language? language,
    List<Level> levels,
    Student? student,
    int id,
    String className,
  ) {
    if (_loaderEntry != null) return;

    final context = GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    _loaderEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(color: Colors.black26),
            ),
          ),

          /// Dialog Center
          Center(
            child: AlertDialog.adaptive(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Center(child: Text('Homework is Set!')),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 200,
                    child: Lottie.asset(
                      AnimationAsset.popupsuccess,
                      fit: BoxFit.fill,
                      repeat: false,
                    ),
                  ),
                  Row(
                    children: [
                      Text('✅'),
                      Text(
                        '10 Phrase created',
                        style: TextTheme.of(context).titleSmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('✅'),
                      Text(
                        'Notification Sent',
                        style: TextTheme.of(context).titleSmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('✅'),
                      Text(
                        'Due ${formatDate(time)}',
                        style: TextTheme.of(context).titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => hide(
                        language: language,
                        levels: levels,
                        student: student,
                        id: id,
                        className: className,
                      ),
                      child: Text('Try it out'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    GoRouter.of(
      ctx!,
    ).routerDelegate.navigatorKey.currentState?.overlay?.insert(_loaderEntry!);
  }

  static void hide({
    required Language? language,
    required List<Level> levels,
    required Student? student,
    required int id,
    required String className,
  }) {
    _loaderEntry?.remove();
    _loaderEntry = null;
    NavigationHelper.go(
      RouteNames.phrasesDetails,
      extra: {
        'language': language,
        "className": className,
        "level": levels,
        'student': student,
        'homework': id,
      },
    );
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
