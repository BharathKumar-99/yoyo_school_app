import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:yoyo_school_app/features/profile/data/profile_repository.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';

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
    isFromOtp = fromOtp;
    _subscribeToUserData();
    Provider.of<GlobalProvider>(ctx!, listen: false);
  }

  void _subscribeToUserData() {
    isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    _userSubscription = profileRepository.getUserDataStream().listen(
      (userData) async {
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
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      },
      onError: (error) {
        debugPrint('User stream error: $error');
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
      },
    );
  }

  Future<void> pickImage(BuildContext context) async {
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
  }

  Future<void> saveImageButton() async {
    if (localImage != null) {
      final result = await profileRepository.saveImage(localImage);
      if (!result) {
        UsefullFunctions.showSnackBar(ctx!, text.somethingWentWrong);
        return;
      } else {
        UsefullFunctions.showSnackBar(ctx!, text.profileUpdated);
      }
    }
    NavigationHelper.go(RouteNames.home);
  }

  logout() async {
    await profileRepository.logout();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    email.dispose();
    super.dispose();
  }
}
