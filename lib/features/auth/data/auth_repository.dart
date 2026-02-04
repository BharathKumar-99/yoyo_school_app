import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/bootstrap/notification_services.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';
import '../../../core/supabase/supabase_client.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

  Future<Map<String, dynamic>> getUserDeviceAndAppInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    Map<String, dynamic> deviceData = {
      'os': 'unknown',
      'device_name': 'unknown',
      'device_model': 'unknown',
    };

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      deviceData = {
        'os': 'Android ${android.version.release}',
        'device_name': android.brand,
        'device_model': android.model,
        'manufacturer': android.manufacturer,
        'sdk_int': android.version.sdkInt,
      };
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      deviceData = {
        'os': 'iOS ${ios.systemVersion}',
        'device_name': ios.name,
        'device_model': ios.model,
        'identifier': ios.identifierForVendor,
      };
    }

    return {
      'app': {
        'name': packageInfo.appName,
        'package': packageInfo.packageName,
        'version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
      },
      'device': deviceData,
      'timestamp': DateTime.now().toIso8601String(),
    };
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
      final res = await client.auth.getUser();

      final user = res.user;
      print("Updated metadata: ${user?.userMetadata}");
      try {
        await client
            .from(DbTable.users)
            .update({
              'activation_code': null,
              'is_activated': true,
              'is_logged_in': true,
              'last_login': DateTime.now().toIso8601String(),
              'user_login_info': await getUserDeviceAndAppInfo(),
            })
            .eq('user_id', userid);
        await NotificationServices().saveFcmToFireBase(userid);
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
      await prefs.setString('user_id', user['user_id']);

      return await ensureAnonymous(user['user_id'], user['school']);
    } on Exception {
      rethrow;
    } catch (c) {
      log(c.toString());
      rethrow;
    }
  }

  Future<void> requestNewActivationCode(String username) async {
    try {
      final data = await client
          .from(DbTable.users)
          .select('''*,${DbTable.studentClasses}(*)''')
          .ilike('username', username)
          .maybeSingle();

      UserModel userModel = UserModel.fromJson(data!);
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      final fcmToken = await messaging.getToken();
      int classId = userModel.studentClasses?.first.classId ?? 0;
      await client.from(DbTable.activationRequests).insert({
        'username': username,
        'class': classId,
        'fcm': fcmToken,
      });

      await client
          .from(DbTable.teacher)
          .update({'notification': true})
          .eq('classes', classId);
    } catch (e) {
      log(e.toString());
    }
  }
}
