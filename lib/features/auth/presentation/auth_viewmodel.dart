import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import '../data/auth_repository.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel(this._repository);

  bool isLoading = false;
  String? errorMessage;
  UserModel? user;

  TextEditingController emailTextEditingCtrl = TextEditingController();

  Future<void> login() async {
    try {
      isLoading = true;
      notifyListeners();
      NavigationHelper.go(RouteNames.home);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
