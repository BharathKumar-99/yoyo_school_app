import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/features/auth/data/auth_repository.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  String? errorMessage;

  TextEditingController userNameTextEditingCtrl = TextEditingController();
  TextEditingController activationTextEditingCtrl = TextEditingController();

  AuthViewModel(UserModel? model) {
    userNameTextEditingCtrl.text = model?.username ?? '';
    activationTextEditingCtrl.text = model?.activationCode ?? '';
  }

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
        Provider.of<ProfileProvider>(ctx!, listen: false).initialize();
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
