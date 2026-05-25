import '../models/category_model.dart';
import 'api_service.dart';

class CategoryService {
  CategoryService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.dio.get<dynamic>('/categories');
    return _extractList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
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
}
