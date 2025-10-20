import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

class PhrasesDeatilsRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<List<UserResult>> getAllUserResults(List<int> ids) async {
    final response = await _client
        .from(DbTable.userResult)
        .select()
        .eq('score_submited', true)
        .inFilter('phrases_id', ids);
    final List<UserResult> results = (response)
        .map((e) => UserResult.fromJson(e))
        .toList();

    return results;
  }
}
