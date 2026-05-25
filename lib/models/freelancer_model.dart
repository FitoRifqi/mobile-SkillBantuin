import 'task_models.dart';

class FreelancerModel {
  final int id;
  final String name;
  final String skill;
  final double rating;
  final int completedProjects;
  final int baseRate;
  final String responseTime;
  final String bio;
  final String email;
  final String phone;

  const FreelancerModel({
    required this.id,
    required this.name,
    required this.skill,
    required this.rating,
    required this.completedProjects,
    required this.baseRate,
    required this.responseTime,
    required this.bio,
    required this.email,
    required this.phone,
  });

  factory FreelancerModel.fromJson(Map<String, dynamic> json) {
    return FreelancerModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name'] ?? json['nama']),
      skill: _parseString(
        json['skill'] ??
            json['keahlian'] ??
            json['category'] ??
            json['kategori'],
      ),
      rating: _parseDouble(json['rating']),
      completedProjects: _parseInt(
        json['completed_projects'] ??
            json['completedTasks'] ??
            json['completed_tasks'] ??
            json['total_projects'],
      ),
      baseRate: _parseInt(
        json['base_rate'] ?? json['price'] ?? json['rate'] ?? json['harga'],
      ),
      responseTime: _parseString(
        json['response_time'] ?? json['responseTime'] ?? json['respon'],
      ),
      bio:
          _parseString(json['bio'] ?? json['description'] ?? json['deskripsi']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone'] ?? json['no_hp']),
    );
  }

  RecommendedFreelancer toRecommendedFreelancer() {
    return RecommendedFreelancer(
      name: name,
      skill: skill.isEmpty ? 'Helper SkillBantuin' : skill,
      rating: rating == 0 ? 4.8 : rating,
      responseTime: responseTime.isEmpty ? '< 1 jam' : responseTime,
      baseRate: baseRate,
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _parseDouble(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(Object? value) {
    return value?.toString() ?? '';
  }
}
