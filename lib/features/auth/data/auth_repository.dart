import '../models/user_model.dart';
import '../../../core/supabase/supabase_client.dart';

class AuthRepository {
  final client = SupabaseClientService.instance.client;

  Future<UserModel?> login(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) return null;
    return UserModel.fromSupabase(response.user!);
  }
}
