import 'user_role.dart';

class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String phoneNumber;
  final UserRole role;
  final String token;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.role,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'role': role.name,
      'token': token,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.client,
      ),
      token: json['token'] as String,
    );
  }
}
