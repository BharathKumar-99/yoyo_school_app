import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/features/profile/data/profile_repository.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';

import '../../../core/supabase/supabase_client.dart';
import '../../common/presentation/global_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository;

  final TextEditingController email = TextEditingController();

  UserModel? user;
  bool isLoading = true;
  bool isFromOtp = false;
  File? localImage;
  String? nameFromUser;

  StreamSubscription<UserModel?>? _userSubscription;

  ProfileProvider(this.profileRepository);

  void initialize({bool fromOtp = false}) {
    try {
      isFromOtp = fromOtp;
      _subscribeToUserData();
      Provider.of<GlobalProvider>(ctx!, listen: false);
    } catch (e) {
      debugPrint("ProfileProvider initialize error: $e");
    }
  }

  void _subscribeToUserData() {
    try {
      isLoading = true;

      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

      _userSubscription = profileRepository.getUserDataStream().listen(
        (userData) async {
          try {
            if (userData == null) return;

            user = userData;

            if (isFromOtp) {
              if (user?.lastLogin != null) {
              } else {
                profileRepository.updateLastLogin();
              }
            }

            nameFromUser = [
              user?.firstName?.isNotEmpty == true ? user!.firstName![0] : '',
              user?.surName?.isNotEmpty == true ? user!.surName![0] : '',
            ].join().toUpperCase();

            email.text = user?.email ?? "";
            isLoading = false;

            WidgetsBinding.instance.addPostFrameCallback(
              (_) => notifyListeners(),
            );
          } catch (e) {
            debugPrint("User stream inner error: $e");
          }
        },
        onError: (error) {
          debugPrint('User stream error: $error');
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => notifyListeners(),
          );
        },
      );
    } catch (e) {
      debugPrint("ProfileProvider subscribe error: $e");
    }
  }

  Future<void> pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();

      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(text.chooseFromGallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(text.takeAPhoto),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        localImage = File(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("pickImage error: $e");
      UsefullFunctions.showSnackBar(ctx!, text.somethingWentWrong);
    }
  }

  Future<void> saveImageButton() async {
    try {
      if (localImage != null) {
        final result = await profileRepository.saveImage(localImage);
        if (!result) {
          UsefullFunctions.showSnackBar(ctx!, text.somethingWentWrong);
          return;
        } else {
          UsefullFunctions.showSnackBar(ctx!, text.profileUpdated);
        }
      }

      if (isFromOtp) {
        NavigationHelper.go(RouteNames.splash);
      } else {
        NavigationHelper.go(RouteNames.home);
      }
    } catch (e) {
      debugPrint("saveImageButton error: $e");
      UsefullFunctions.showSnackBar(ctx!, text.somethingWentWrong);
    }
  }

  Future<void> logoutUser() async {
    ctx!.pop();
    try {
      await SupabaseClientService.instance.client.auth.signOut();
    } catch (e) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ctx!.go(RouteNames.login);
  }

  Future<void> logout() async {
    try {
      showDialog(
        context: ctx!,
        builder: (context) => AlertDialog.adaptive(
          title: Text(text.areYouSure),
          content: Text(text.logoutMsg),
          scrollable: true,
          actionsOverflowDirection: VerticalDirection.up,
          actionsAlignment: MainAxisAlignment.center,
          alignment: Alignment.center,
          actions: [
            Center(
              child: TextButton(
                onPressed: () async {
                  await logoutUser();
                },
                child: Text(
                  text.logout,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textTheme.titleSmall!.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ctx!.pop();
                },
                child: Text(
                  text.loggedIn,
                  style: AppTextStyles.textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }

  @override
  void dispose() {
    try {
      _userSubscription?.cancel();
      email.dispose();
      super.dispose();
    } catch (e) {
      debugPrint("ProfileProvider dispose error: $e");
    }
  }
}
