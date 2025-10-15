import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/attempt_phrases_model.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

class PhrasesDeatilsRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<List<UserResult>> getAllUserResults(List<int> ids) async {
    final response = await _client
        .from(DbTable.userResult)
        .select()
        .inFilter('phrases_id', ids);

    final List<UserResult> results = (response)
        .map((e) => UserResult.fromJson(e))
        .toList();

    return results;
  }

  Future<List<AttemptedPhrase>> getRecordedPhrases(
    int launguageId,
    int studentId,
    List<UserResult> results,
  ) async {
    List<AttemptedPhrase> phrases = [];
    final data = await _client
        .from(DbTable.attemptedPhrases)
        .select('''
      *,
      ${DbTable.phrase}(*)        
    ''')
        .eq('student_id', studentId)
        .eq('${DbTable.phrase}.language', launguageId);

    for (var val in data) {
      AttemptedPhrase ph = AttemptedPhrase.fromJson(val);
      final sc = results.firstWhere(
        (val) => val.phrasesId == ph.phrasesId,
        orElse: () => UserResult(),
      );
      ph.phrase?.score = sc.score ?? 0;
      phrases.add(ph);
    }
    return phrases;
  }
}
