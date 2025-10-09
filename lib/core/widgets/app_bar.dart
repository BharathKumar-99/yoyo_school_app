import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';

PreferredSizeWidget getAppBar(BuildContext context) {
  final topPadding = MediaQuery.of(context).padding.top;

  return PreferredSize(
    preferredSize: Size.fromHeight(80 + topPadding),
    child: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      flexibleSpace: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: EdgeInsets.only(
              top: topPadding + 10, // Respect iOS notch
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(ImageConstants.logoHome, height: 55, width: 55),
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
                        fit: BoxFit.cover,
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
          );
        },
      ),
    ),
  );
}
