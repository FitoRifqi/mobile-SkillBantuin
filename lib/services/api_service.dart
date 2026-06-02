import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final String _baseUrl = AppConfig.baseUrl;

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.post(
      uri,
      headers: _buildHeaders(token),
      body: jsonEncode(body ?? {}),
    );
    return _parseResponse(response);
  }

  Future<dynamic> get(
    String path, {
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.get(uri, headers: _buildHeaders(token));
    return _parseResponse(response);
  }

  Map<String, String> _buildHeaders(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  dynamic _parseResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = (body is Map && body['message'] != null)
            ? body['message']
            : (body is Map && body['errors'] is Map)
                ? (body['errors'] as Map).values.first.toString()
                : 'Terjadi kesalahan jaringan. Silakan coba lagi.';

    throw ApiException(message.toString());
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
