import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/home/model/level_model.dart';

class UsefullFunctions {
  UsefullFunctions._();

  static void showToast(
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    Color background = Colors.black87,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: background,
        duration: duration,
      ),
    );
  }

  static String returnLevel(int id, List<Level>? levels) {
    final levelName = levels
        ?.firstWhere((val) => val.id == id, orElse: () => Level(level: "NA"))
        .level;

    return ((levelName?.length ?? 0) >= 2
            ? levelName?.substring(0, 2)
            : levelName) ??
        "NA";
  }
}
