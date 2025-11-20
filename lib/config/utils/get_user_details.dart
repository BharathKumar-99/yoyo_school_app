import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

class GetUserDetails {
  GetUserDetails._();

  static String? getCurrentUserId() {
    try {
      final client = SupabaseClientService.instance.client;

      final User? currentUser = client.auth.currentUser;

      return currentUser?.userMetadata?['user_id'];
    } catch (e) {
      log('Error getting user ID: $e');
      return null;
    }
  }

  static int? getCurrentSchool() {
    try {
      final client = SupabaseClientService.instance.client;

      final User? currentUser = client.auth.currentUser;

      return currentUser?.userMetadata?['school'];
    } catch (e) {
      log('Error getting user ID: $e');
      return null;
    }
  }
}
