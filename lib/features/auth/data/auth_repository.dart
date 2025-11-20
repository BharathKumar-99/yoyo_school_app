import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/supabase/supabase_client.dart';

class AuthRepository {
  final client = SupabaseClientService.instance.client;

  Future<void> login(String email) async {
    try {
      await client.auth.signInWithOtp(email: email);
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  Future<Map> ensureAnonymous(String userid, int id) async {
    try {
      final auth = client.auth;
      if (auth.currentSession == null) {
        await auth.signInAnonymously();
      }
      client.auth.updateUser(
        UserAttributes(data: {'user_id': userid, 'school': id}),
      );
      try {
        await client
            .from(DbTable.users)
            .update({'activation_code': null, 'is_activated': true})
            .eq('user_id', userid);
      } catch (e) {
        rethrow;
      }
      return {'success': true, 'message': text.userFound};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map> loginWithActivationCode(String username, String code) async {
    try {
      final resp = await client
          .from(DbTable.users)
          .select()
          .ilike('username', username)
          .maybeSingle();

      if (resp == null) return {'success': false, 'message': text.userNotFound};
      final Map user = resp as Map;

      if (user['activation_code'] == null) {
        return {'success': false, 'message': text.invalidActivationToken};
      }
      if (user['activation_code'].toString() != code) {
        return {'success': false, 'message': text.invalidActivationToken};
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('logged_in_user', username);
      return await ensureAnonymous(user['user_id'], user['school']);
    } on Exception {
      rethrow;
    }
  }

  Future<void> requestNewActivationCode(String username) async {
    await client.from(DbTable.activationRequests).insert({
      'username': username,
    });
  }

  void verifyOtp(String otp, String email) async {
    try {
      await client.auth.verifyOTP(
        type: OtpType.email,
        token: otp,
        email: email,
      );
      NavigationHelper.push(RouteNames.splash);
    } catch (e) {
      log(e.toString());
      UsefullFunctions.showSnackBar(ctx!, text.otp_expired);
    }
  }
}
