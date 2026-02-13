import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';
import 'login_view_model.dart';

class LoginScreen extends StatelessWidget {
  final UserModel? user;
  const LoginScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(user),
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                Image.asset(ImageConstants.loginBg),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(ImageConstants.appLogo),
                        Container(
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
                                SizedBox(height: 15),
                                Text(
                                  text.login_text,
                                  style: AppTextStyles.textTheme.headlineLarge,
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: vm.userNameTextEditingCtrl,
                                  style: AppTextStyles.textTheme.bodySmall,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    hintText: text.user_name,
                                    hintStyle: AppTextStyles
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Image.asset(
                                        IconConstants.emailIcon,
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      maxHeight: 40,
                                      maxWidth: 40,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: vm.activationTextEditingCtrl,
                                  inputFormatters: [ActivationCodeFormatter()],
                                  style: AppTextStyles.textTheme.bodySmall,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    hintText: text.activation_code,
                                    hintStyle: AppTextStyles
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.grey),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Image.asset(
                                        IconConstants.lockIcon,
                                      ),
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      maxHeight: 40,
                                      maxWidth: 40,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => vm.login(),
                                    child: Text(
                                      text.login_btn,
                                      style:
                                          AppTextStyles.textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: TextButton(
              onPressed: () {
                NavigationHelper.push(RouteNames.needActivationCode);
              },
              child: Text(
                text.requestNewCode,
                style: AppTextStyles.textTheme.bodyMedium!.copyWith(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActivationCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Detect backspace/delete
    final isDeleting = newValue.text.length < oldValue.text.length;

    // Keep only A-Z and 0-9
    String raw = newValue.text.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );

    // Max raw length = 6
    if (raw.length > 6) {
      raw = raw.substring(0, 6);
    }

    String formatted;

    if (raw.length < 3) {
      formatted = raw;
    } else if (raw.length == 3) {
      // ✅ Add dash ONLY if not deleting
      formatted = isDeleting ? raw : '$raw-';
    } else {
      formatted = '${raw.substring(0, 3)}-${raw.substring(3)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
