import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/auth/data/auth_repository.dart';
import 'package:yoyo_school_app/features/auth/presentation/otp_view_model.dart';

class OtpScreen extends StatelessWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OtpViewModel>(
      create: (context) => OtpViewModel(AuthRepository(), email),
      child: Consumer<OtpViewModel>(
        builder: (context, vm, wid) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Image.asset(ImageConstants.loginBg),
                SafeArea(
                  child: Column(
                    children: [
                      Image.asset(ImageConstants.appLogo),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                                Text(
                                  text.verify_otp,
                                  style: AppTextStyles.textTheme.headlineLarge,
                                ),
                                SizedBox(height: 40),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${text.otp_header} ",
                                        style: AppTextStyles
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.grey),
                                      ),
                                      TextSpan(
                                        text: email,
                                        style: AppTextStyles
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 30,
                                  ),
                                  child: PinCodeTextField(
                                    controller: vm.pinCodeController,
                                    appContext: context,
                                    length: 6,
                                    onAutoFillDisposeAction:
                                        AutofillContextAction.commit,
                                    onCompleted: (value) => vm.verifyOtp(),
                                    keyboardType: TextInputType.number,
                                    autoFocus: true,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    cursorColor: Colors.grey,
                                    animationType: AnimationType.fade,
                                    animationDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    enableActiveFill: true,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(12),
                                      activeBorderWidth: 1.5,
                                      inactiveBorderWidth: 1.5,
                                      selectedBorderWidth: 1.5,
                                      activeFillColor: Colors.white,
                                      inactiveFillColor: Colors.white,
                                      selectedFillColor: Colors.grey[400],
                                      activeColor: Color(0xFF6155F5),
                                      inactiveColor: Colors.grey[400],
                                      selectedColor: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => vm.verifyOtp(),
                                    child: Text(
                                      text.verify_otp,
                                      style:
                                          AppTextStyles.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      text.resend_otp,
                                      style: AppTextStyles.textTheme.bodyMedium!
                                          .copyWith(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
