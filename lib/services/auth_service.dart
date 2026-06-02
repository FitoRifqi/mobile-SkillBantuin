import '../models/app_user.dart';
import '../models/user_role.dart';
import 'api_service.dart';
import 'session_service.dart';

class AuthService {
  AuthService({
    SessionService? sessionService,
    ApiService? apiService,
  })  : _sessionService = sessionService ?? SessionService(),
        _apiService = apiService ?? ApiService();

  final SessionService _sessionService;
  final ApiService _apiService;

  Future<AppUser> login({
    required String identity,
    required String password,
    required UserRole role,
    required bool rememberMe,
  }) async {
    final response = await _apiService.post(
      '/login',
      body: {
        'identity': identity.trim(),
        'password': password,
      },
    );

    final data = Map<String, dynamic>.from(response['user'] as Map<String, dynamic>);
    data['token'] = response['token'];
    final user = AppUser.fromJson(data);

    if (rememberMe) {
      await _sessionService.saveSession(user);
    } else {
      await _sessionService.clearSession();
    }

    return user;
  }

  Future<AppUser> register({
    required String fullName,
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
    required UserRole role,
    required bool keepSignedIn,
  }) async {
    final response = await _apiService.post(
      '/register',
      body: {
        'name': fullName.trim(),
        'username': username.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'role': role.name,
        'phone': phoneNumber.trim(),
      },
    );

    final data = Map<String, dynamic>.from(response['user'] as Map<String, dynamic>);
    data['token'] = response['token'];
    final user = AppUser.fromJson(data);

    if (keepSignedIn) {
      await _sessionService.saveSession(user);
    } else {
      await _sessionService.clearSession();
    }

    return user;
  }

  Future<AppUser?> getSavedSession() {
    return _sessionService.getSession();
  }

  Future<void> logout() async {
    final savedSession = await _sessionService.getSession();
    if (savedSession != null && savedSession.token.isNotEmpty) {
      try {
        await _apiService.post('/logout', token: savedSession.token);
      } catch (_) {
        // ignore logout errors; still clear local session
      }
    }
    return _sessionService.clearSession();
  }
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
