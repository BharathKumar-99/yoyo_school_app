// lib/services/log_service.dart (Updated Snippet)
// ... (Keep ErrorLogEntry and most of LogService class structure)

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/router/navigation_tracker.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/common/model/error_log_model.dart';

class LogService {
  Future<void> logError({
    required dynamic error,
    required StackTrace stackTrace,
    String? errorCode,
  }) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceModel = '';
    String osInfo = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceModel = androidInfo.model;
      osInfo = androidInfo.version.release;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo.modelName;
      osInfo = iosInfo.systemName;
    }

    final user = GetUserDetails.getCurrentUserId();

    final userActionDescription = routeTracker.currentRouteStack;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    final logEntry = ErrorLogEntry(
      username: user ?? 'anonymous',
      deviceModel: deviceModel,
      osVersion: osInfo,
      appVersion: version,
      userAction: userActionDescription,
      errorCode: errorCode,
      errorMessage: error.toString(),
      stackTrace: stackTrace.toString(),
    );

    final SupabaseClient client = SupabaseClientService.instance.client;
    await client.from(DbTable.errorLogs).insert(logEntry.toSupabaseJson());
  }
}

final logService = LogService();
