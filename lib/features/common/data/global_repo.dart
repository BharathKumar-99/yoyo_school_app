import 'dart:async';
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';

import '../../../config/constants/constants.dart';
import '../../result/model/user_result_model.dart';

class GlobalRepo {
  final SupabaseClient _client = SupabaseClientService.instance.client;

  RealtimeChannel? _userResultChannel;

  Stream<List<UserResult>> streamAllUserResults(List<int> ids) async* {
    final response = await _client
        .from(DbTable.userResult)
        .select()
        .eq('score_submited', true)
        .inFilter('phrases_id', ids);

    List<UserResult> currentResults = response
        .map<UserResult>((e) => UserResult.fromJson(e))
        .toList();

    final controller = StreamController<List<UserResult>>();

    controller.add(currentResults);

    _userResultChannel = _client.channel('user_result_updates');

    _userResultChannel!
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: DbTable.userResult,

          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'phrases_id',
            value: ids,
          ),
          callback: (payload) async {
            log('Realtime update received: ${payload.toString()}');

            final newResponse = await _client
                .from(DbTable.userResult)
                .select()
                .eq('score_submited', true)
                .inFilter('phrases_id', ids);

            final updatedResults = newResponse
                .map<UserResult>((e) => UserResult.fromJson(e))
                .toList();

            controller.add(updatedResults);
          },
        )
        .subscribe();

    yield* controller.stream;
  }

  void disposeStream() {
    if (_userResultChannel != null) {
      _client.removeChannel(_userResultChannel!);
      _userResultChannel = null;
    }
  }
}
