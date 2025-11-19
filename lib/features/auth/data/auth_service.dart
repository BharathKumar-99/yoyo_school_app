import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final SupabaseClient client = Supabase.instance.client;



  Future<void> logoutHard() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user');
    // Do not sign out the anonymous session completely, you can choose to keep it.
    // If you want to clear Supabase auth session, uncomment below:
    // await client.auth.signOut();
  }

  Future<String?> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('logged_in_user');
  }
}
