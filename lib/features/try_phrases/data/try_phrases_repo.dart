import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';

import '../../../config/constants/constants.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../home/model/language_model.dart';
import '../../result/model/user_result_model.dart';

class TryPhrasesRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;
  Future<UserResult?> getAttemptedPhrase(int pid) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    final data = await _client
        .from(DbTable.userResult)
        .select('*')
        .eq('user_id', userId)
        .eq('phrases_id', pid)
        .eq('type', Constants.learned)
        .maybeSingle();
    if (data == null) {
      return null;
    }
    return UserResult.fromJson(data);
  }

  Future<Language> getPhraseModelData(int id) async {
    final data = await _client
        .from(DbTable.language)
        .select('*')
        .eq('id', id)
        .maybeSingle();
    return Language.fromJson(data!);
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
            'type': result.type,
          })
          .select("*")
          .maybeSingle();
    }
    return UserResult.fromJson(data!);
  }

  updateStreak(int? lid, String uid, int streak) async {
    final response = await _client
        .from(DbTable.streakTable)
        .select('max_streak')
        .eq('user_id', uid)
        .eq('language_id', lid ?? 0)
        .maybeSingle();

    int currentStreak = response?['max_streak'] ?? 0;

    if (currentStreak < streak) {
      await _client
          .from(DbTable.streakTable)
          .update({'max_streak': streak})
          .eq('user_id', uid)
          .eq('language_id', lid ?? 0);
    }
  }
}
