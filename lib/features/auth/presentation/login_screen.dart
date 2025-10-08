import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                  ),
                                  child: Image.asset(ImageConstants.schoolLogo),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  text.login_text,
                                  style: AppTextStyles.textTheme.headlineLarge,
                                ),
                                SizedBox(height: 40),
                                TextField(
                                  controller: vm.emailTextEditingCtrl,
                                  style: AppTextStyles.textTheme.bodySmall,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(16),
                                    hintText: text.email_address,
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
                                SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => vm.login(),
                                    child: Text(
                                      text.send_otp,
                                      style:
                                          AppTextStyles.textTheme.titleMedium,
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
