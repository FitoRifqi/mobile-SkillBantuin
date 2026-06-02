import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

class SessionService {
  static const String _sessionKey = 'skillbantuin_session';
  static const String _onboardingKey = 'skillbantuin_onboarding_seen';

  SessionService({SharedPreferences? sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> get _prefs async {
    return _sharedPreferences ?? await SharedPreferences.getInstance();
  }

  Future<void> saveSession(AppUser user) async {
    final prefs = await _prefs;
    await prefs.setString(_sessionKey, jsonEncode(user.toJson()));
  }

  Future<AppUser?> getSession() async {
    final prefs = await _prefs;
    final rawSession = prefs.getString(_sessionKey);
    if (rawSession == null || rawSession.isEmpty) return null;

    try {
      return AppUser.fromJson(
        jsonDecode(rawSession) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
  }

  Future<bool> isOnboardingSeen() async {
    final prefs = await _prefs;
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> markOnboardingSeen() async {
    final prefs = await _prefs;
    await prefs.setBool(_onboardingKey, true);
  }
}
