import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';

AppBar getAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    toolbarHeight: 80,
    flexibleSpace: Consumer<ProfileProvider>(
      builder: (context, provider, we) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(ImageConstants.logoHome),
                GestureDetector(
                  onTap: () =>
                      NavigationHelper.push(RouteNames.profile, extra: false),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image:
                            (provider.user?.image == null ||
                                provider.user!.image!.isEmpty)
                            ? const AssetImage(ImageConstants.loginBg)
                            : CachedNetworkImageProvider(provider.user!.image!)
                                  as ImageProvider,

                        fit: BoxFit.fill,
                      ),
                    ),
                    child: (provider.user?.image?.isEmpty ?? true)
                        ? Center(
                            child: Text(
                              provider.nameFromUser ?? "",
                              style: AppTextStyles.textTheme.headlineLarge!
                                  .copyWith(color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
