import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel();

  String? errorMessage;

  TextEditingController emailTextEditingCtrl = TextEditingController();

  Future<void> login() async {
    String email = emailTextEditingCtrl.text.trim();
    try {
      NavigationHelper.push(RouteNames.otp, extra: email);
    } catch (e) {
      errorMessage = e.toString();
    } finally {}
  }
}
