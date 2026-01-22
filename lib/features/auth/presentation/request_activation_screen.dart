import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'request_activation_view_model.dart';

class RequestActivationScreen extends StatelessWidget {
  const RequestActivationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RequestActivationViewModel(),
      child: Consumer<RequestActivationViewModel>(
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
                                SizedBox(height: 30),
                                Text(
                                  text.needActivationCode,
                                  style: AppTextStyles.textTheme.headlineLarge,
                                ),
                                SizedBox(height: 40),
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

                                SizedBox(height: 30),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => vm.requestActivationcode(),
                                    child: Text(
                                      text.requestActivationcode,
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 40,
                  ),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.black,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      fixedSize: WidgetStateProperty.all(const Size(40, 40)),
                    ),
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
