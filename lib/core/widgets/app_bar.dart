import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';

AppBar getAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,

    automaticallyImplyLeading: false,
    toolbarHeight: 80,
    titleSpacing: 0,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.go(RouteNames.home),

                child: SizedBox(
                  height: 55,
                  width: 55,
                  child: Image.asset(
                    ImageConstants.logoHome,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    NavigationHelper.push(RouteNames.profile, extra: false),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          const AssetImage(ImageConstants.loginBg)
                              as ImageProvider,
                    ),
                  ),

                  child: Center(
                    child: Text(
                      provider.nameFromUser ?? "",
                      style: AppTextStyles.textTheme.headlineLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
