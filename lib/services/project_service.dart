import '../models/project_model.dart';
import 'api_service.dart';

class ProjectService {
  ProjectService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<ProjectModel>> getProjects() async {
    final response = await _apiService.dio.get<dynamic>('/projects');
    return _parseProjects(response.data);
  }

  Future<List<ProjectModel>> getProjectsByCategory(int kategoriId) async {
    final response = await _apiService.dio.get<dynamic>(
      '/projects',
      queryParameters: {'category_id': kategoriId},
    );
    return _parseProjects(response.data);
  }

  Future<List<ProjectModel>> getProjectsByStatus(String status) async {
    final response = await _apiService.dio.get<dynamic>(
      '/projects',
      queryParameters: {'status': status},
    );
    return _parseProjects(response.data);
  }

  Future<ProjectModel> getProjectDetail(String id) async {
    final response = await _apiService.dio.get<dynamic>('/projects/$id');
    final data = _extractObject(response.data);
    return ProjectModel.fromJson(data);
  }

  List<ProjectModel> _parseProjects(dynamic responseData) {
    return _extractList(responseData)
        .whereType<Map<String, dynamic>>()
        .map(ProjectModel.fromJson)
        .toList();
  }

  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic> && data['data'] is List) {
        return data['data'] as List;
      }
    }
    return const [];
  }

  Map<String, dynamic> _extractObject(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final data = responseData['data'];
      if (data is Map<String, dynamic>) return data;
      return responseData;
    }
    return const {};
  }
}
