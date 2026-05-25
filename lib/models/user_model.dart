import 'user_role.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseId(json['id']),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: _parseRole(json['role']),
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'phone': phone,
    };
  }

  static int _parseId(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static UserRole _parseRole(Object? value) {
    final rawRole = value?.toString().toLowerCase().trim();
    if (rawRole == UserRole.freelancer.name || rawRole == 'helper') {
      return UserRole.freelancer;
    }
    return UserRole.client;
  }
}
