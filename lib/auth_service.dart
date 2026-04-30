// lib/auth_service.dart
// Temporary in-memory "database" for users

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  // Pre-seeded demo account
  final Map<String, String> _users = {
    'demo': 'password123',
  };

  String? _loggedInUser;
  String? get loggedInUser => _loggedInUser;

  /// Returns null on success, or an error code string on failure.
  /// Error codes: 'username_taken'
  String? register(String username, String password) {
    final key = username.trim().toLowerCase();
    if (_users.containsKey(key)) return 'username_taken';
    _users[key] = password;
    return null;
  }

  /// Returns null on success, or an error code string on failure.
  /// Error codes: 'user_not_found' | 'wrong_password'
  String? login(String username, String password) {
    final key = username.trim().toLowerCase();
    if (!_users.containsKey(key)) return 'user_not_found';
    if (_users[key] != password) return 'wrong_password';
    _loggedInUser = key;
    return null;
  }

  void logout() => _loggedInUser = null;
}