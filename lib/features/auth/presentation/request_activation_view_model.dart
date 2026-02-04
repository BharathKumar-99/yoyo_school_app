import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/features/auth/data/auth_repository.dart';

import '../../../config/router/navigation_helper.dart';

class RequestActivationViewModel extends ChangeNotifier {
  TextEditingController userNameTextEditingCtrl = TextEditingController();
  final AuthRepository _repository = AuthRepository();
  void requestActivationcode() async {
    String userName = userNameTextEditingCtrl.text.trim();
    FocusScope.of(ctx!).unfocus();
    if (userName.isEmpty) {
      return UsefullFunctions.showSnackBar(ctx!, 'Please Enter All Fields');
    }
    try {
      WidgetsBinding.instance.addPostFrameCallback((v) => GlobalLoader.show());
      await _repository.requestNewActivationCode(userName);
    } catch (e) {
      return UsefullFunctions.showSnackBar(ctx!, e.toString());
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((v) => GlobalLoader.hide());
      userNameTextEditingCtrl.clear();
    }
  }
}
