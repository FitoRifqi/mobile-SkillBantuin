import '../config/api_endpoints.dart';
import 'api_client.dart';
import 'session_service.dart';

class LaravelTaskService {
  LaravelTaskService({
    ApiClient? apiClient,
    SessionService? sessionService,
  })  : _sessionService = sessionService ?? SessionService(),
        _apiClient = apiClient;

  final ApiClient? _apiClient;
  final SessionService _sessionService;

  ApiClient get _client {
    return _apiClient ??
        ApiClient(
          tokenProvider: () async {
            final user = await _sessionService.getSession();
            return user?.token;
          },
        );
  }

  Future<List<Map<String, dynamic>>> getClientTasks() async {
    final response = await _client.get(ApiEndpoints.clientTasks);
    return _readList(response);
  }

  Future<Map<String, dynamic>> createClientTask({
    required String title,
    required String category,
    required String description,
    required int budget,
    required String deadline,
    required String assistanceType,
    String? location,
  }) {
    return _client.post(
      ApiEndpoints.clientTasks,
      body: {
        'title': title,
        'category': category,
        'description': description,
        'budget': budget,
        'deadline': deadline,
        'assistance_type': assistanceType,
        'location': location,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAvailableTasks() async {
    final response = await _client.get(ApiEndpoints.availableTasks);
    return _readList(response);
  }

  Future<Map<String, dynamic>> sendOffer({
    required String taskId,
    required int offeredBudget,
    required String proposedDeadline,
    required String message,
  }) {
    return _client.post(
      ApiEndpoints.taskOffers(taskId),
      body: {
        'offered_budget': offeredBudget,
        'proposed_deadline': proposedDeadline,
        'message': message,
      },
    );
  }

  Future<Map<String, dynamic>> acceptOffer({
    required String taskId,
    required String offerId,
  }) {
    return _client.post(ApiEndpoints.acceptOffer(taskId, offerId));
  }

  Future<Map<String, dynamic>> createPayment({
    required String taskId,
  }) {
    return _client.post(ApiEndpoints.taskPayment(taskId));
  }

  Future<Map<String, dynamic>> submitWorkResult({
    required String taskId,
    required String note,
    required String resultUrl,
  }) {
    return _client.post(
      ApiEndpoints.submitWorkResult(taskId),
      body: {
        'note': note,
        'result_url': resultUrl,
      },
    );
  }

  Future<Map<String, dynamic>> reviewTask({
    required String taskId,
    required int rating,
    required String review,
  }) {
    return _client.post(
      ApiEndpoints.reviewTask(taskId),
      body: {
        'rating': rating,
        'review': review,
      },
    );
  }

  List<Map<String, dynamic>> _readList(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }
}
