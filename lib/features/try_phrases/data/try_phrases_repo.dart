import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/router/navigation_helper.dart';
import 'package:yoyo_school_app/config/utils/get_user_details.dart';
import 'package:yoyo_school_app/config/utils/usefull_functions.dart'; // import your utility

import '../../../config/constants/constants.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../home/model/language_model.dart';
import '../../result/model/user_result_model.dart';

class TryPhrasesRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  static const Duration _timeoutDuration = Duration(seconds: 10);

  Future<UserResult?> getAttemptedPhrase(int pid) async {
    try {
      final userId = GetUserDetails.getCurrentUserId() ?? "";
      final data = await _client
          .from(DbTable.userResult)
          .select('*')
          .eq('user_id', userId)
          .eq('phrases_id', pid)
          .eq('type', Constants.learned)
          .timeout(_timeoutDuration);

      return data.isEmpty ? null : UserResult.fromJson(data.last);
    } on TimeoutException {
      UsefullFunctions.showSnackBar(ctx!, 'Time Out Error');
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Language?> getPhraseModelData(int id) async {
    try {
      final data = await _client
          .from(DbTable.language)
          .select('*')
          .eq('id', id)
          .maybeSingle()
          .timeout(_timeoutDuration);

      return data != null ? Language.fromJson(data) : null;
    } on TimeoutException {
      UsefullFunctions.showSnackBar(ctx!, 'Time Out Error');
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResult?> upsertResult(UserResult result) async {
    try {
      PostgrestList? data;
      if (result.id != null) {
        data = await _client
            .from(DbTable.userResult)
            .update({'listens': result.listen})
            .eq('id', result.id ?? 0)
            .select("*")
            .timeout(_timeoutDuration);
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
            .timeout(_timeoutDuration);
      }

      return data.isNotEmpty ? UserResult.fromJson(data.last) : null;
    } on TimeoutException {
      UsefullFunctions.showSnackBar(ctx!, 'Time Out Error');
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
