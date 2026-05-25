import 'task_models.dart';

class CategoryModel {
  final int id;
  final String name;
  final String description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name'] ?? json['title'] ?? json['nama']),
      description: _parseString(
        json['description'] ?? json['subtitle'] ?? json['deskripsi'],
      ),
    );
  }

  HelperCategory toHelperCategory() {
    return HelperCategory(
      title: name,
      subtitle: description.isEmpty ? 'Kategori Bantuan' : description,
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(Object? value) {
    return value?.toString() ?? '';
  }
}
