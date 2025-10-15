import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

class PhraseRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<Language> getPhraseModelData(int id) async {
    final data = await _client
        .from(DbTable.language)
        .select('*')
        .eq('id', id)
        .maybeSingle();
    return Language.fromJson(data!);
  }

  Future<UserResult?> getAttemptedPhrase(int pid) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final data = await _client
        .from(DbTable.userResult)
        .select('*')
        .eq('user_id', userId)
        .eq('phrases_id', pid)
        .maybeSingle();
    if (data == null) {
      return null;
    }
    return UserResult.fromJson(data);
  }

  Future<UserResult> upsertResult(UserResult result) async {
    PostgrestMap? data;
    if (result.id != null) {
      data = await _client
          .from(DbTable.userResult)
          .update({'listens': result.listen})
          .eq('id', result.id ?? 0)
          .select("*")
          .maybeSingle();
    } else {
      data = await _client
          .from(DbTable.userResult)
          .insert({
            'user_id': result.userId,
            'phrases_id': result.phrasesId,
            'listens': 1,
          })
          .select("*")
          .maybeSingle();
    }
    return UserResult.fromJson(data!);
  }
}
