// lib/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _supabase = Supabase.instance.client;

  String? get loggedInUser => _supabase.auth.currentUser?.email;

  /// Returns null on success, or an error code string on failure.
  Future<String?> register(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  /// Returns null on success, or an error code string on failure.
  Future<String?> login(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}