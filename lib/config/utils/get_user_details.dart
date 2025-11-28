import 'dart:developer';

import 'package:yoyo_school_app/config/utils/shared_preferences.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

class GetUserDetails {
  GetUserDetails._();

  static String? getCurrentUserId() {
    try {
      final client = SupabaseClientService.instance.client;
      return client.auth.currentUser?.userMetadata?['user_id'] ??
          SharedPrefsService.prefs.getString('user_id');
    } catch (e) {
      log('Error getting user ID: $e');
      return null;
    }
  }
}
