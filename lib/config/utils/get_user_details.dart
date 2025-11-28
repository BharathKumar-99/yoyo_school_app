import 'dart:developer';

import 'package:yoyo_school_app/config/utils/shared_preferences.dart';

class GetUserDetails {
  GetUserDetails._();

  static String? getCurrentUserId() {
    try {
      return SharedPrefsService.prefs.getString('user_id');
    } catch (e) {
      log('Error getting user ID: $e');
      return null;
    }
  }
}
