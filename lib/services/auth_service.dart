import '../models/app_user.dart';
import '../models/user_role.dart';
import 'session_service.dart';

class AuthService {
  AuthService({
    SessionService? sessionService,
  }) : _sessionService = sessionService ?? SessionService();

  final SessionService _sessionService;

  static final List<_MockAccount> _accounts = [
    const _MockAccount(
      id: 'client-001',
      fullName: 'Nadia Client',
      email: 'client@skillbantuin.demo',
      username: 'clientdemo',
      phoneNumber: '081234567890',
      password: 'demo123',
      role: UserRole.client,
    ),
    const _MockAccount(
      id: 'freelancer-001',
      fullName: 'Raka Freelancer',
      email: 'freelancer@skillbantuin.demo',
      username: 'freelancerdemo',
      phoneNumber: '089876543210',
      password: 'demo123',
      role: UserRole.freelancer,
    ),
  ];

  Future<AppUser> login({
    required String identity,
    required String password,
    required UserRole role,
    required bool rememberMe,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final normalizedIdentity = identity.trim().toLowerCase();
    final account = _accounts.where((item) => item.role == role).cast<_MockAccount?>().firstWhere(
          (item) =>
              item != null &&
              (item.username.toLowerCase() == normalizedIdentity ||
                  item.email.toLowerCase() == normalizedIdentity),
          orElse: () => null,
        );

    if (account == null || account.password != password) {
      throw const AuthException(
        'Akun tidak ditemukan atau password salah untuk peran yang dipilih.',
      );
    }

    final user = account.toAppUser();
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
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedUsername = username.trim().toLowerCase();

    final alreadyExists = _accounts.any(
      (item) =>
          item.email.toLowerCase() == normalizedEmail ||
          item.username.toLowerCase() == normalizedUsername,
    );

    if (alreadyExists) {
      throw const AuthException(
        'Email atau username sudah dipakai. Gunakan data demo yang berbeda.',
      );
    }

    final account = _MockAccount(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: normalizedEmail,
      username: username.trim(),
      phoneNumber: phoneNumber.trim(),
      password: password,
      role: role,
    );
    _accounts.add(account);

    final user = account.toAppUser();

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

  Future<void> logout() {
    return _sessionService.clearSession();
  }
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class _MockAccount {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String phoneNumber;
  final String password;
  final UserRole role;

  const _MockAccount({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.role,
  });

  AppUser toAppUser() {
    return AppUser(
      id: id,
      fullName: fullName,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      role: role,
      token: 'mock-token-$id',
    );
  }
}
