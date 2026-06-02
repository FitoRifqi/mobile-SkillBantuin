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

  Future<dynamic> postMultipart(
    String path, {
    required Map<String, String> fields,
    required String fileField,
    required String filePath,
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_buildMultipartHeaders(token))
      ..fields.addAll(fields)
      ..files.add(await http.MultipartFile.fromPath(fileField, filePath));

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return _parseResponse(response);
  }

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.put(
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

  Map<String, String> _buildMultipartHeaders(String? token) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  dynamic _parseResponse(http.Response response) {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};

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

class LaravelResponse {
  LaravelResponse._();

  static List<Map<String, dynamic>> extractList(dynamic raw) {
    final list = _findList(raw);
    return list.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }

  static List<dynamic> _findList(dynamic raw) {
    if (raw is List) return raw;

    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final data = map['data'];

      if (data is List) return data;
      if (data is Map && data['data'] is List) {
        return data['data'] as List;
      }

      for (final key in [
        'items',
        'results',
        'projects',
        'freelancers',
        'offers'
      ]) {
        if (map[key] is List) return map[key] as List;
      }
    }

    return <dynamic>[];
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
