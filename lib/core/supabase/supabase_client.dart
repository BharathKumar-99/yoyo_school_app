import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  SupabaseClientService._();
  static final SupabaseClientService instance = SupabaseClientService._();

  late final SupabaseClient client;

  Future<void> init() async {
    await Supabase.initialize(
      url: 'your-supabase-url',
      anonKey: 'your-supabase-anon-key',
    );
    client = Supabase.instance.client;
  }
}
