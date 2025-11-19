import 'dart:io';
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import '../data/auth_repository.dart';

class OtpViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final String userName;
  TextEditingController pinCodeController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  late OTPTextEditController controller;

  OtpViewModel(this._repository, this.userName) {
    pinCodeController = TextEditingController();

    if (Platform.isAndroid) {
      controller =
          OTPTextEditController(
            codeLength: 6,
            onCodeReceive: (code) {
              pinCodeController.text = code;
              notifyListeners();
            },
          )..startListenUserConsent((code) {
            final exp = RegExp(r'(\d{6})');
            final match = exp.firstMatch(code ?? '');
            return match?.group(0) ?? '';
          });
    } else {
      controller = OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          pinCodeController.text = code;
          notifyListeners();
        },
      );
    }
  }

  Future<void> verifyOtp() async {
    isLoading = true;
    notifyListeners();
    _repository.loginWithActivationCode(
      userName,
      pinCodeController.text.trim().toString(),
    );
    isLoading = false;
    notifyListeners();
  }
}
