import 'dart:async';

import '../models/task_models.dart';
import 'api_service.dart';
import 'mock_task_service.dart';
import 'session_service.dart';

class TaskService {
  TaskService({
    ApiService? apiService,
    SessionService? sessionService,
    MockTaskService? mockTaskService,
  })  : _apiService = apiService ?? ApiService(),
        _sessionService = sessionService ?? SessionService(),
        _mockTaskService = mockTaskService ?? MockTaskService();

  final ApiService _apiService;
  final SessionService _sessionService;
  final MockTaskService _mockTaskService;

  Future<String?> _getToken() async {
    final session = await _sessionService.getSession();
    return session?.token;
  }

  Future<dynamic> _tryGet(List<String> paths, {String? token}) async {
    dynamic lastError;
    for (final path in paths) {
      try {
        return await _apiService.get(path, token: token);
      } catch (error) {
        lastError = error;
      }
    }
    if (lastError != null) {
      throw lastError;
    }
    throw ApiException('Tidak ada endpoint task yang tersedia.');
  }

  List<Map<String, dynamic>> _extractList(dynamic raw,
      {List<String> keys = const ['data', 'items', 'tasks', 'results']}) {
    final laravelList = LaravelResponse.extractList(raw);
    if (laravelList.isNotEmpty) return laravelList;

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      for (final key in keys) {
        if (map[key] is List) {
          return (map[key] as List)
              .whereType<Map>()
              .map(Map<String, dynamic>.from)
              .toList();
        }
      }
    }

    return [];
  }

  Future<List<ClientTask>> fetchClientTasks() async {
    try {
      final token = await _getToken();
      final raw = await _tryGet(
        [
          '/my-projects',
          '/client/tasks',
          '/tasks/client',
          '/tasks',
          '/client/activities'
        ],
        token: token,
      );
      final list =
          _extractList(raw, keys: ['data', 'tasks', 'clientTasks', 'items']);
      if (list.isEmpty) return _mockTaskService.getClientTasks();
      return list.map(ClientTask.fromJson).toList();
    } catch (_) {
      return _mockTaskService.getClientTasks();
    }
  }

  Future<List<AvailableTask>> fetchAvailableTasks() async {
    try {
      final token = await _getToken();
      final raw = await _tryGet(
        [
          '/projects?status=open',
          '/projects',
          '/freelancer/tasks',
          '/tasks/available'
        ],
        token: token,
      );
      final list =
          _extractList(raw, keys: ['data', 'tasks', 'availableTasks', 'items']);
      if (list.isEmpty) return _mockTaskService.getAvailableTasks();
      return list.map(AvailableTask.fromJson).toList();
    } catch (_) {
      return _mockTaskService.getAvailableTasks();
    }
  }

  Future<List<FreelancerWorkItem>> fetchFreelancerWorks() async {
    try {
      final token = await _getToken();
      final raw = await _tryGet(
        ['/my-offers', '/freelancer/works', '/works', '/tasks/assigned'],
        token: token,
      );
      final list = _extractList(raw, keys: ['data', 'works', 'items']);
      if (list.isEmpty) return _mockTaskService.getFreelancerWorks();
      return list.map(FreelancerWorkItem.fromJson).toList();
    } catch (_) {
      return _mockTaskService.getFreelancerWorks();
    }
  }

  Future<List<EarningTransaction>> fetchEarningTransactions() async {
    try {
      final token = await _getToken();
      final raw = await _tryGet(
        ['/transactions', '/freelancer/earnings', '/earnings', '/financials'],
        token: token,
      );
      final list = _extractList(raw, keys: ['data', 'earnings', 'items']);
      if (list.isEmpty) return _mockTaskService.getEarningTransactions();
      return list.map(EarningTransaction.fromJson).toList();
    } catch (_) {
      return _mockTaskService.getEarningTransactions();
    }
  }
}
