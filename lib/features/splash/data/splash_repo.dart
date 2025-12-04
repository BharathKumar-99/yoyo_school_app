import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';
import 'package:yoyo_school_app/features/splash/app_config_model.dart';

class SplashRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;
  Future<UserModel?> getProfileData() async {
    if (GetUserDetails.getCurrentUserId() != null) {
      final data = await _client
          .from(DbTable.users)
          .select('*')
          .eq('user_id', GetUserDetails.getCurrentUserId()!)
          .single();

      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<AppConfigModel?> getAppConfig() async {
    final data = await _client
        .from(DbTable.appConfig)
        .select('*')
        .limit(1)
        .maybeSingle();
    return AppConfigModel.fromJson(data!);
  }
}
