import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/profile/presentation/profile_provider.dart';

class YourProfile extends StatefulWidget {
  final bool? isFromOtp;
  const YourProfile({super.key, this.isFromOtp = false});

  @override
  State<YourProfile> createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
  late ProfileProvider provider;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.initialize(fromOtp: widget.isFromOtp ?? false);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return provider.isLoading
            ? const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              )
            : Scaffold(
                appBar: AppBar(
                  leadingWidth: 80,
                  leading: IconButton(
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
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                  actions: [
                    PopupMenuButton<int>(
                      offset: const Offset(0, -380),
                      enableFeedback: false,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text(text.settings),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            context.push(RouteNames.settings);
                            break;
                          default:
                        }
                      },
                      child: Image.asset(
                        IconConstants.vertIcon,
                        height: 24,
                        width: 24,
                      ),
                    ),

                    const SizedBox(width: 10),
                    (widget.isFromOtp ?? false)
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () => provider.logout(),
                            child: Image.asset(
                              IconConstants.logOutIcon,
                              height: 31,
                              width: 31,
                            ),
                          ),
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
                          color: const Color.fromRGBO(14, 14, 23, 0.42),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => provider.pickImage(context),
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: provider.localImage != null
                                    ? FileImage(provider.localImage!)
                                    : provider.user?.image?.isNotEmpty == true
                                    ? CachedNetworkImageProvider(
                                        provider.user?.image ?? '',
                                      )
                                    : const AssetImage(ImageConstants.loginBg)
                                          as ImageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                            child:
                                (provider.localImage == null &&
                                    (provider.user?.image?.isEmpty ?? true))
                                ? Center(
                                    child: Text(
                                      provider.nameFromUser ?? "",
                                      style: AppTextStyles
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(color: Colors.white),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      TextField(
                        controller: provider.email,
                        style: AppTextStyles.textTheme.bodySmall,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(16),
                          hintText: text.email_address,
                          hintStyle: AppTextStyles.textTheme.bodySmall!
                              .copyWith(color: Colors.grey),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
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
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => provider.saveImageButton(),
                      child: Text(
                        text.save,
                        style: AppTextStyles.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
