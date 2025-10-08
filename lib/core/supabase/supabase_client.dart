import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  SupabaseClientService._();
  static final SupabaseClientService instance = SupabaseClientService._();

  late final SupabaseClient client;

  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://xijaobuybkpfmyxcrobo.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhpamFvYnV5YmtwZm15eGNyb2JvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxOTMwOTEsImV4cCI6MjA3NDc2OTA5MX0.NXUL474MOuf-5YXxby4BZzWgrTcsRkLj5rxLU3jf3JI',
    );
    client = Supabase.instance.client;
  }
}
