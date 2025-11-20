import 'dart:async';
import 'dart:developer';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/result/model/user_result_model.dart';

import '../../../config/utils/get_user_details.dart';
import '../model/phrase_categories_model.dart';

class PhrasesDeatilsRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  Future<List<UserResult>> getUserResults() async {
    final newResponse = await _client
        .from(DbTable.userResult)
        .select()
        .eq('score_submited', true);

    return newResponse.map<UserResult>((e) => UserResult.fromJson(e)).toList();
  }

  Future<int>? getStreakValue(String uid, int? lid) async {
    final response = await _client
        .from(DbTable.streakTable)
        .select('max_streak')
        .eq('user_id', uid)
        .eq('language_id', lid ?? 0)
        .maybeSingle();
    return response?['max_streak'] ?? 0;
  }

  Future<List<PhraseCategoriesModel>> getAllPhraseCategories(int id) async {
    final response = await _client
        .from(DbTable.phraseCategories)
        .select('*')
        .eq('language', id);
    return response
        .map<PhraseCategoriesModel>((e) => PhraseCategoriesModel.fromJson(e))
        .toList();
  }

  Future<List<UserResult>> getUserResult(List<int> ids) async {
    final response = await _client
        .from(DbTable.userResult)
        .select()
        .eq('score_submited', true)
        .inFilter('phrases_id', ids);

    return response.map<UserResult>((e) => UserResult.fromJson(e)).toList();
  }

  Future<void> insertStreak(String uid, int? lid) async {
    await _client
        .from(DbTable.streakTable)
        .upsert(
          {'user_id': uid, 'language_id': lid, 'max_streak': 0},
          onConflict: 'user_id,language_id',
          ignoreDuplicates: true,
        );
  }

  Future<void> resetPhrase(int id, int studenId) async {
    final userId = GetUserDetails.getCurrentUserId() ?? "";
    try {
      await _client
          .from(DbTable.userResult)
          .delete()
          .eq('phrases_id', id)
          .eq('user_id', userId);
      await _client
          .from(DbTable.attemptedPhrases)
          .delete()
          .eq('phrases_id', id)
          .eq('student_id', studenId);
    } catch (e) {
      log("issue here");
    }
  }
}
