import '../models/app_user.dart';
import '../models/user_role.dart';
import '../config/api_endpoints.dart';
import 'api_client.dart';
import 'session_service.dart';

class LaravelAuthService {
  LaravelAuthService({
    ApiClient? apiClient,
    SessionService? sessionService,
  })  : _sessionService = sessionService ?? SessionService(),
        _apiClient = apiClient ??
            ApiClient(
                tokenProvider:
                    (sessionService ?? SessionService()).getSessionToken);

  final ApiClient _apiClient;
  final SessionService _sessionService;

  Future<AppUser> login({
    required String identity,
    required String password,
    required UserRole role,
    required bool rememberMe,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      authenticated: false,
      body: {
        'identity': identity.trim(),
        'password': password,
        'role': role.name,
        'device_name': 'SkillBantuin Flutter',
      },
    );

    final user = _parseAuthUser(response, fallbackRole: role);
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
    final response = await _apiClient.post(
      ApiEndpoints.register,
      authenticated: false,
      body: {
        'full_name': fullName.trim(),
        'name': fullName.trim(),
        'email': email.trim(),
        'username': username.trim(),
        'phone_number': phoneNumber.trim(),
        'password': password,
        'password_confirmation': password,
        'role': role.name,
        'device_name': 'SkillBantuin Flutter',
      },
    );

    final user = _parseAuthUser(response, fallbackRole: role);
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
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } finally {
      await _sessionService.clearSession();
    }
  }

  AppUser _parseAuthUser(
    Map<String, dynamic> response, {
    required UserRole fallbackRole,
  }) {
    final data = response['data'];
    final root = data is Map<String, dynamic> ? data : response;
    final rawUser = root['user'] is Map<String, dynamic>
        ? root['user'] as Map<String, dynamic>
        : root;
    final token = root['token'] ??
        root['access_token'] ??
        response['token'] ??
        response['access_token'];

    return AppUser.fromJson({
      ...rawUser,
      'role': rawUser['role'] ?? fallbackRole.name,
      'token': token ?? rawUser['token'] ?? '',
    });
  }
}
