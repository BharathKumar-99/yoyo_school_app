import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
}
