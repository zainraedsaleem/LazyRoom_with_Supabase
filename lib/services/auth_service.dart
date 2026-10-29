import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takroom/models/register_request_model.dart';
import 'package:takroom/models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //register
  Future<bool> register(RegisterRequestModel user) async {
    final response = await _supabase.auth.signUp(
      email: user.email,
      password: user.password,
      data: {
        'name': user.name,
        'room_number': user.roomNumber,
        'building': user.buildingNumber,
      },
    );
    return response.user != null;
  }

  //login
  Future<bool> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (_) {
      try {
        await _supabase.auth.signOut(scope: SignOutScope.local);
      } catch (_) {}
    }
  }

  //get Current User Profile
  Future<UserModel> getCurrentUserProfile() async {
    final authUser = _supabase.auth.currentUser;
    if (authUser == null) {
      throw Exception('Not Logged in');
    }

    final data = await _supabase
        .from('users')
        .select()
        .eq('id', authUser.id)
        .single();
    return UserModel.fromJson(data, email: authUser.email ?? '');
  }
}
