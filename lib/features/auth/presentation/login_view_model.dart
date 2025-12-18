import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/features/auth/data/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel();
  final AuthRepository _repository = AuthRepository();
  String? errorMessage;

  TextEditingController userNameTextEditingCtrl = TextEditingController();
  TextEditingController activationTextEditingCtrl = TextEditingController();

  Future<void> login() async {
    String userName = userNameTextEditingCtrl.text.trim();

    String activationCode = activationTextEditingCtrl.text.trim();
    FocusScope.of(ctx!).unfocus();

    if (userName.isEmpty || activationCode.isEmpty) {
      return UsefullFunctions.showSnackBar(ctx!, 'Please Enter All Fields');
    }
    try {
      WidgetsBinding.instance.addPostFrameCallback((v) => GlobalLoader.show());
      final data = await _repository.loginWithActivationCode(
        userName,
        activationCode,
      );
      if (data['success']) {
        NavigationHelper.push(RouteNames.splash);
      } else {
        UsefullFunctions.showSnackBar(ctx!, data['message']);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((v) => GlobalLoader.hide());
    }
  }
}
