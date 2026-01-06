import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';

class SupabaseClientService {
  SupabaseClientService._();
  static final SupabaseClientService instance = SupabaseClientService._();

  late final SupabaseClient client;

  Future<void> init() async {
    await Supabase.initialize(
      url: Constants.dev
          ? SupabaseConstants.devSupabaseUrl
          : SupabaseConstants.prodSupabaseUrl,
      anonKey: Constants.dev
          ? SupabaseConstants.devSupabaseKey
          : SupabaseConstants.prodSupabaseKey,
    );
    client = Supabase.instance.client;
  }
}
