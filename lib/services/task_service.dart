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
    if (raw is List) {
      return raw.cast<Map<String, dynamic>>();
    }

    if (raw is Map<String, dynamic>) {
      for (final key in keys) {
        if (raw[key] is List) {
          return (raw[key] as List).cast<Map<String, dynamic>>();
        }
      }
    }

    return [];
  }

  Future<List<ClientTask>> fetchClientTasks() async {
    try {
      final token = await _getToken();
      final raw = await _tryGet(
        ['/client/tasks', '/tasks/client', '/tasks', '/client/activities'],
        token: token,
      );
      final list = _extractList(raw, keys: ['data', 'tasks', 'clientTasks', 'items']);
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
        ['/freelancer/tasks', '/tasks/available', '/tasks', '/available-tasks'],
        token: token,
      );
      final list = _extractList(raw, keys: ['data', 'tasks', 'availableTasks', 'items']);
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
        ['/freelancer/works', '/works', '/tasks/assigned', '/freelancer/assignments'],
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
        ['/freelancer/earnings', '/earnings', '/transactions', '/financials'],
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
