import 'package:flutter/material.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';

class YourProfile extends StatelessWidget {
  const YourProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: IconButton(
          onPressed: () => NavigationHelper.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey),
              ),
            ),
            fixedSize: WidgetStateProperty.all(const Size(40, 40)),
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),

        actions: [
          Image.asset(IconConstants.vertIcon, height: 24, width: 24),
          SizedBox(width: 10),
          Image.asset(IconConstants.logOutIcon, height: 31, width: 31),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text(
              text.your_profile,
              style: AppTextStyles.textTheme.headlineLarge,
            ),
            Text(
              text.profile_header,

              style: AppTextStyles.textTheme.bodyMedium!.copyWith(
                color: Color.fromRGBO(14, 14, 23, 0.42),
              ),
            ),
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: AssetImage(ImageConstants.loginBg),
                  ),
                ),
                child: Center(
                  child: Text(
                    "BF",
                    style: AppTextStyles.textTheme.headlineLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            TextField(
              style: AppTextStyles.textTheme.bodySmall,
              enabled: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hintText: text.email_address,
                hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Image.asset(IconConstants.emailIcon),
                ),
                prefixIconConstraints: const BoxConstraints(
                  maxHeight: 40,
                  maxWidth: 40,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => NavigationHelper.pop(),
            child: Text(text.back, style: AppTextStyles.textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}
