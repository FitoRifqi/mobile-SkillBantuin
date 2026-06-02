import 'package:flutter/foundation.dart';

import '../models/project_model.dart';
import '../services/api_service.dart';
import '../services/session_service.dart';

class ProjectProvider extends ChangeNotifier {
  final ApiService apiService;
  final SessionService _sessionService;

  ProjectProvider(this.apiService, this._sessionService);

  final List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProjectModel> get projects => List.unmodifiable(_projects);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProjects({int page = 1, Map<String, String>? params}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final queryParams = <String, String>{};
      if (page > 1) queryParams['page'] = page.toString();
      if (params != null) queryParams.addAll(params);

      final path = queryParams.isNotEmpty
          ? '/projects?${Uri(queryParameters: queryParams).query}'
          : '/projects';

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

      final items = (listData as List).map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e))).toList();

      _projects
        ..clear()
        ..addAll(items);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> _getToken() async {
    final session = await _sessionService.getSession();
    return session?.token;
  }

  Future<void> fetchMyProjects({int page = 1, Map<String, String>? params}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      final queryParams = <String, String>{};
      if (page > 1) queryParams['page'] = page.toString();
      if (params != null) queryParams.addAll(params);

      final path = queryParams.isNotEmpty
          ? '/my-projects?${Uri(queryParameters: queryParams).query}'
          : '/my-projects';

      final resp = await apiService.get(path, token: token);

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

      final items = (listData as List).map((e) => ProjectModel.fromJson(Map<String, dynamic>.from(e))).toList();

      _projects
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
    _projects.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
