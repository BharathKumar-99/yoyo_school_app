import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

import '../../home/model/school_model.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<void> logout() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    await _client.auth.signOut();
    NavigationHelper.go(RouteNames.login);
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
  }

  Future<School?> getSchoolData(int id) async {
    try {
      final data = await _client
          .from(DbTable.school)
          .select('*')
          .eq('id', id)
          .maybeSingle();
      return School.fromJson(data!);
    } catch (e) {
      return null;
    }
  }

  Stream<UserModel?> getUserDataStream() {
    final userId = GetUserDetails.getCurrentUserId() ?? "";

    try {
      return _client
          .from(DbTable.users)
          .stream(primaryKey: ['user_id'])
          .eq('user_id', userId)
          .map((event) {
            if (event.isNotEmpty) {
              return UserModel.fromJson(event.first);
            }
            return null;
          });
          
    } catch (e, st) {
      log('Realtime UserData Error: $e\n$st');
      return const Stream.empty();
    }
  }

  void updateLastLogin() async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    await _client
        .from(DbTable.users)
        .update({'last_login': DateTime.now().toIso8601String()})
        .eq('user_id', userId);
  }
}
