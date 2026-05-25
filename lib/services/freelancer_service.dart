import '../models/freelancer_model.dart';
import 'api_service.dart';

class FreelancerService {
  FreelancerService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<FreelancerModel>> getFreelancers() async {
    final response = await _apiService.dio.get<dynamic>('/freelancers');
    return _parseFreelancers(response.data);
  }

  Future<List<FreelancerModel>> getFreelancersBySkill(String keahlian) async {
    final response = await _apiService.dio.get<dynamic>(
      '/freelancers',
      queryParameters: {'skill': keahlian},
    );
    return _parseFreelancers(response.data);
  }

  Future<FreelancerModel> getFreelancerDetail(String id) async {
    final response = await _apiService.dio.get<dynamic>('/freelancers/$id');
    final data = _extractObject(response.data);
    return FreelancerModel.fromJson(data);
  }

  List<FreelancerModel> _parseFreelancers(dynamic responseData) {
    return _extractList(responseData)
        .whereType<Map<String, dynamic>>()
        .map(FreelancerModel.fromJson)
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
