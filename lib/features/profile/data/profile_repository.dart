import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/router/route_names.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/global_loader.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

import '../model/user_model.dart';

class ProfileRepository {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<void> logout() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.show());
    await _client.auth.signOut();
    NavigationHelper.go(RouteNames.login);
    WidgetsBinding.instance.addPostFrameCallback((_) => GlobalLoader.hide());
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

  Future<bool> saveImage(File? localImage) async {
    if (localImage == null) return false;
    GlobalLoader.show();
    final userId = GetUserDetails.getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      GlobalLoader.hide();
      return false;
    }

    try {
      final filePath = '$userId/profile_image.jpg';

      try {
        await _client.storage.from(Stroage.userBucket).remove([filePath]);
      } catch (e) {
        debugPrint('Upload Error: $e');
        GlobalLoader.hide();
        return false;
      }

      await _client.storage
          .from(Stroage.userBucket)
          .upload(
            filePath,
            localImage,
            fileOptions: const FileOptions(upsert: true),
          );

      final profileUrl = _client.storage
          .from(Stroage.userBucket)
          .getPublicUrl(filePath);

      await _client
          .from(DbTable.users)
          .update({'image': profileUrl})
          .eq('user_id', userId);
      GlobalLoader.hide();
      return true;
    } on StorageException catch (e) {
      debugPrint('Storage error: ${e.message}');
      GlobalLoader.hide();
      return false;
    } on PostgrestException catch (e) {
      debugPrint('Database error: ${e.message}');
      GlobalLoader.hide();
      return false;
    } on SocketException {
      debugPrint('No internet connection.');
      GlobalLoader.hide();
      return false;
    } catch (e, st) {
      debugPrint('Unexpected error while saving image: $e\n$st');
      GlobalLoader.hide();
      return false;
    }
  }
}
