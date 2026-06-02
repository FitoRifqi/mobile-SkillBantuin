import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;

  AppUser? _user;
  String? _error;
  bool _isLoading = false;
  AuthStatus _status = AuthStatus.idle;

  AppUser? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  AuthStatus get status => _status;
  bool get isAuthenticated => _user != null && _user!.token.isNotEmpty;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      final savedUser = await _authService.getSavedSession();
      if (savedUser != null && savedUser.token.isNotEmpty) {
        _user = savedUser;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (error) {
      _status = AuthStatus.unauthenticated;
      _error = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login({
    required String identity,
    required String password,
    required bool rememberMe,
    required UserRole role,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      _user = await _authService.login(
        identity: identity,
        password: password,
        role: role,
        rememberMe: rememberMe,
      );
      _status = AuthStatus.authenticated;
    } catch (error) {
      _status = AuthStatus.error;
      _error = error.toString();
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
    required UserRole role,
    required bool keepSignedIn,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      _user = await _authService.register(
        fullName: fullName,
        email: email,
        username: username,
        phoneNumber: phoneNumber,
        password: password,
        role: role,
        keepSignedIn: keepSignedIn,
      );
      _status = AuthStatus.authenticated;
    } catch (error) {
      _status = AuthStatus.error;
      _error = error.toString();
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.logout();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (error) {
      _status = AuthStatus.error;
      _error = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
