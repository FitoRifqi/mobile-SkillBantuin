import '../models/chat_message_model.dart';
import '../models/category_model.dart';
import '../models/offer_model.dart';
import '../models/project_model.dart';
import '../models/task_models.dart';
import 'api_service.dart';
import 'session_service.dart';

class MarketplaceService {
  MarketplaceService({
    ApiService? apiService,
    SessionService? sessionService,
  })  : _apiService = apiService ?? ApiService(),
        _sessionService = sessionService ?? SessionService();

  final ApiService _apiService;
  final SessionService _sessionService;

  Future<String?> _getToken() async {
    final session = await _sessionService.getSession();
    return session?.token;
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    final token = await _getToken();
    final response = await _apiService.get('/profile', token: token);
    if (response is Map && response['data'] is Map) {
      return Map<String, dynamic>.from(response['data'] as Map);
    }
    return Map<String, dynamic>.from(response as Map);
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    required String bio,
    String? skill,
    String? company,
    String? alamat,
    String? portfolio,
    int? hargaPerHari,
    int? pengalamanTahun,
  }) async {
    final token = await _getToken();
    final response = await _apiService.put(
      '/profile',
      token: token,
      body: {
        'name': name,
        'phone': phone,
        'bio': bio,
        if (skill != null) 'skill': skill,
        if (company != null) 'company': company,
        if (alamat != null) 'alamat': alamat,
        if (portfolio != null) 'portfolio': portfolio,
        if (hargaPerHari != null) 'harga_per_hari': hargaPerHari,
        if (pengalamanTahun != null) 'pengalaman_tahun': pengalamanTahun,
      },
    );
    if (response is Map && response['data'] is Map) {
      return Map<String, dynamic>.from(response['data'] as Map);
    }
    return Map<String, dynamic>.from(response as Map);
  }

  Future<Map<String, dynamic>> submitReview({
    required String projectId,
    required int rating,
    required String comment,
  }) async {
    final token = await _getToken();
    final response = await _apiService.post(
      '/projects/$projectId/review',
      token: token,
      body: {
        'rating': rating,
        'comment': comment,
      },
    );
    if (response is Map && response['data'] is Map) {
      return Map<String, dynamic>.from(response['data'] as Map);
    }
    return Map<String, dynamic>.from(response as Map);
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _apiService.get('/categories');
    return LaravelResponse.extractList(response)
        .map(CategoryModel.fromJson)
        .toList();
  }

  Future<void> applyToProject({
    required String projectId,
    required int offeredBudget,
    required String message,
    required int proposedDeadlineDays,
  }) async {
    final token = await _getToken();
    await _apiService.post(
      '/projects/$projectId/apply',
      token: token,
      body: {
        'offered_budget': offeredBudget,
        'message': message,
        'proposed_deadline_days': proposedDeadlineDays,
      },
    );
  }

  Future<Map<String, dynamic>> createProject({
    required String title,
    required String description,
    required int categoryId,
    required int budget,
    required DateTime deadline,
    String? attachmentFilePath,
  }) async {
    if (budget < 1000 || budget > 99998000) {
      throw ApiException('Budget harus di antara Rp1.000 dan Rp99.998.000.');
    }

    final token = await _getToken();
    final body = {
      'judul': title,
      'deskripsi': description,
      'kategori_id': categoryId,
      'anggaran_min': budget,
      'anggaran_max': budget + 1000,
      'deadline': deadline.toIso8601String().split('T').first,
    };
    final response = attachmentFilePath == null
        ? await _apiService.post('/projects', token: token, body: body)
        : await _apiService.postMultipart(
            '/projects',
            token: token,
            fileField: 'attachment_file',
            filePath: attachmentFilePath,
            fields: body.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          );
    if (response is Map && response['project'] is Map) {
      return Map<String, dynamic>.from(response['project'] as Map);
    }
    return Map<String, dynamic>.from(response as Map);
  }

  Future<Map<String, dynamic>> submitProjectResult({
    required String projectId,
    required String resultFilePath,
    String? resultLink,
    required String resultNote,
  }) async {
    final token = await _getToken();
    final response = await _apiService.postMultipart(
      '/projects/$projectId/submit-result',
      token: token,
      fileField: 'result_file',
      filePath: resultFilePath,
      fields: {
        if (resultLink != null && resultLink.isNotEmpty)
          'result_link': resultLink,
        'result_note': resultNote,
      },
    );
    if (response is Map && response['data'] is Map) {
      return Map<String, dynamic>.from(response['data'] as Map);
    }
    return Map<String, dynamic>.from(response as Map);
  }

  Future<List<OfferModel>> fetchProjectOffers(String projectId) async {
    final token = await _getToken();
    final response = await _apiService.get(
      '/projects/$projectId/offers',
      token: token,
    );
    return LaravelResponse.extractList(response)
        .map(OfferModel.fromJson)
        .toList();
  }

  Future<List<VolunteerOffer>> fetchProjectVolunteerOffers(
      String projectId) async {
    final token = await _getToken();
    final response = await _apiService.get(
      '/projects/$projectId/offers',
      token: token,
    );
    return LaravelResponse.extractList(response)
        .map(VolunteerOffer.fromJson)
        .toList();
  }

  Future<List<OfferModel>> fetchMyOffers() async {
    final token = await _getToken();
    final response = await _apiService.get('/my-offers', token: token);
    return LaravelResponse.extractList(response)
        .map(OfferModel.fromJson)
        .toList();
  }

  Future<List<ProjectModel>> fetchMyProjects() async {
    final token = await _getToken();
    final response = await _apiService.get('/my-projects', token: token);
    return LaravelResponse.extractList(response)
        .map(ProjectModel.fromJson)
        .toList();
  }

  Future<void> acceptOffer(String offerId) async {
    final token = await _getToken();
    await _apiService.put('/offers/$offerId/accept', token: token);
  }

  Future<void> rejectOffer(String offerId) async {
    final token = await _getToken();
    await _apiService.put('/offers/$offerId/reject', token: token);
  }

  Future<void> counterOffer({
    required String offerId,
    required int offeredBudget,
    required String message,
    int? proposedDeadlineDays,
  }) async {
    final token = await _getToken();
    await _apiService.put(
      '/offers/$offerId/counter',
      token: token,
      body: {
        'offered_budget': offeredBudget,
        'message': message,
        if (proposedDeadlineDays != null)
          'proposed_deadline_days': proposedDeadlineDays,
      },
    );
  }

  Future<void> acceptCounterOffer(String offerId) async {
    final token = await _getToken();
    await _apiService.put('/offers/$offerId/accept-counter', token: token);
  }

  Future<List<ChatMessageModel>> fetchChats(String projectId) async {
    final token = await _getToken();
    final response = await _apiService.get('/chats/$projectId', token: token);
    return LaravelResponse.extractList(response)
        .map(ChatMessageModel.fromJson)
        .toList();
  }

  Future<ChatMessageModel> sendChat({
    required String projectId,
    required String content,
  }) async {
    final token = await _getToken();
    final response = await _apiService.post(
      '/chats/$projectId',
      token: token,
      body: {
        'content': content,
        'message_type': 'text',
      },
    );
    final data = response is Map && response['data'] is Map
        ? Map<String, dynamic>.from(response['data'] as Map)
        : Map<String, dynamic>.from(response as Map);
    return ChatMessageModel.fromJson(data);
  }

  Future<Map<String, dynamic>> createPayment(String projectId) async {
    final token = await _getToken();
    final response =
        await _apiService.post('/projects/$projectId/pay', token: token);
    return Map<String, dynamic>.from(response as Map);
  }

  Future<String> fetchTransactionStatus(String orderId) async {
    final token = await _getToken();
    final response = await _apiService.get(
      '/transactions/$orderId/status',
      token: token,
    );
    if (response is Map && response['status'] != null) {
      return response['status'].toString();
    }
    return 'unknown';
  }
}
