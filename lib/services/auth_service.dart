import 'package:dio/dio.dart';

import '../models/user_model.dart';
import '../models/user_role.dart';
import 'api_service.dart';
import 'session_service.dart';
import 'token_service.dart';

class AuthService {
  AuthService({
    ApiService? apiService,
    TokenService? tokenService,
    SessionService? sessionService,
  })  : _tokenService = tokenService ?? const TokenService(),
        _sessionService = sessionService ?? SessionService(),
        _apiService = apiService ?? ApiService(tokenService: tokenService);

  final ApiService _apiService;
  final TokenService _tokenService;
  final SessionService _sessionService;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.dio.post<Map<String, dynamic>>(
        '/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      return _saveAuthResponse(response.data);
    } on DioException catch (error) {
      throw AuthException(_getErrorMessage(error));
    } catch (_) {
      throw const AuthException('Terjadi kendala saat login. Coba lagi sebentar.');
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String phone,
  }) async {
    try {
      final response = await _apiService.dio.post<Map<String, dynamic>>(
        '/register',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'role': role.name,
          'phone': phone.trim(),
        },
      );

      return _saveAuthResponse(response.data);
    } on DioException catch (error) {
      throw AuthException(_getErrorMessage(error));
    } catch (_) {
      throw const AuthException(
        'Terjadi kendala saat membuat akun. Coba lagi sebentar.',
      );
    }
  }

  Future<void> logout() async {
    final hasToken = await _tokenService.hasToken();
    if (hasToken) {
      try {
        await _apiService.dio.post<void>('/logout');
      } on DioException {
        // Token lokal tetap dibersihkan walaupun request logout gagal.
      }
    }

    await _tokenService.deleteToken();
    await _sessionService.clearSession();
  }

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiService.dio.get<Map<String, dynamic>>('/profile');
      final data = response.data;
      final userJson = data?['user'] ?? data;

      if (userJson is! Map<String, dynamic>) {
        throw const AuthException('Data profil dari server tidak valid.');
      }

      final user = UserModel.fromJson(userJson);
      await _sessionService.saveSession(user);
      return user;
    } on AuthException {
      rethrow;
    } on DioException catch (error) {
      throw AuthException(_getErrorMessage(error));
    } catch (_) {
      throw const AuthException('Terjadi kendala saat mengambil profil.');
    }
  }

  Future<UserModel?> getSavedSession() {
    return _sessionService.getSession();
  }

  Future<UserModel> _saveAuthResponse(Map<String, dynamic>? data) async {
    final token = data?['token'] as String?;
    final userJson = data?['user'];

    if (token == null || token.isEmpty || userJson is! Map<String, dynamic>) {
      throw const AuthException('Response auth dari server tidak valid.');
    }

    final user = UserModel.fromJson(userJson);
    await _tokenService.saveToken(token);
    await _sessionService.saveSession(user);
    return user;
  }

  String _getErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;

      final errors = data['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        return firstError.toString();
      }
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Tidak bisa terhubung ke server Laravel.';
    }

    return 'Request gagal. Coba lagi sebentar.';
  }
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
