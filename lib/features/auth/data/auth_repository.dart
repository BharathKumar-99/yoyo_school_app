import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';

import '../../../core/supabase/supabase_client.dart';

class AuthRepository {
  final client = SupabaseClientService.instance.client;

  Future<void> login(String email) async {
    try {
      await client.auth.signInWithOtp(email: email);
    } catch (e) {
      log(e.toString());
    }
  }

  void verifyOtp(String otp, String email) async {
    try {
      await client.auth.verifyOTP(
        type: OtpType.email,
        token: otp,
        email: email,
      );
      NavigationHelper.push(RouteNames.profile, extra: true);
    } catch (e) {
      log(e.toString());
    }
  }
}
