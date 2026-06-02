import 'package:flutter/foundation.dart';

import '../models/freelancer_model.dart';
import '../services/api_service.dart';

class FreelancerProvider extends ChangeNotifier {
  final ApiService apiService;

  FreelancerProvider(this.apiService);

  final List<FreelancerModel> _freelancers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<FreelancerModel> get freelancers => List.unmodifiable(_freelancers);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFreelancers({int page = 1, Map<String, String>? params}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final queryParams = <String, String>{};
      if (page > 1) queryParams['page'] = page.toString();
      if (params != null) queryParams.addAll(params);

      final path = queryParams.isNotEmpty
          ? '/freelancers?${Uri(queryParameters: queryParams).query}'
          : '/freelancers';

      final resp = await apiService.get(path);

      dynamic listData;
      if (resp is Map && resp['data'] != null) {
        listData = resp['data'];
      } else if (resp is List) {
        listData = resp;
      } else if (resp is Map && resp['success'] == true && resp['data'] != null) {
        listData = resp['data'];
      } else {
        listData = <dynamic>[];
      }

      final items = (listData as List).map((e) => FreelancerModel.fromJson(Map<String, dynamic>.from(e))).toList();

      _freelancers
        ..clear()
        ..addAll(items);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _freelancers.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
