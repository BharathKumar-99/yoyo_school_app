import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/theme/app_text_styles.dart';
import 'package:yoyo_school_app/features/home/model/school_model.dart';
import 'package:yoyo_school_app/features/profile/data/profile_repository.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';

import '../../../core/supabase/supabase_client.dart';
import '../../common/presentation/global_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository;
  final TextEditingController email = TextEditingController();
  UserModel? user;
  bool isLoading = true;
  String? nameFromUser;
  StreamSubscription<UserModel?>? _userSubscription;
  School? school;

  ProfileProvider(this.profileRepository);

  void initialize() {
    try {
      _subscribeToUserData();
      Provider.of<GlobalProvider>(ctx!, listen: false);
    } catch (e) {
      debugPrint("ProfileProvider initialize error: $e");
    }
  }

  String extractCaps(String text) {
    final caps = RegExp(r'[A-Z]');
    return caps.allMatches(text).map((m) => m.group(0)!).join();
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

            school = await profileRepository.getSchoolData(user?.school ?? 0);
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
        builder: (context) => AlertDialog(
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
