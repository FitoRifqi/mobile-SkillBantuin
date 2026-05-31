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
    final rawRole = json['role']?.toString().toLowerCase();

    return AppUser(
      id: json['id'].toString(),
      fullName: (json['fullName'] ?? json['full_name'] ?? json['name'] ?? '')
          .toString(),
      email: (json['email'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      phoneNumber:
          (json['phoneNumber'] ?? json['phone_number'] ?? '').toString(),
      role: UserRole.values.firstWhere(
        (role) => role.name == rawRole,
        orElse: () => UserRole.client,
      ),
      token: (json['token'] ?? json['access_token'] ?? '').toString(),
    );
  }
}
