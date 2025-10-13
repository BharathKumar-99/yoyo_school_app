import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';
import 'package:yoyo_school_app/core/supabase/supabase_client.dart';
import 'package:yoyo_school_app/features/home/model/language_model.dart';

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
}
