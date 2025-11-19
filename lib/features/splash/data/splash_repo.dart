import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/profile/model/user_model.dart';

class SplashRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;
  Future<UserModel> getProfileData() async {
    final data = await _client
        .from(DbTable.users)
        .select('*')
        .eq('user_id', _client.auth.currentUser?.userMetadata?['user_id'] ?? "")
        .single();

    return UserModel.fromJson(data);
  }
}
