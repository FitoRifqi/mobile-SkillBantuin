import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exception.dart';

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    String? baseUrl,
    TokenProvider? tokenProvider,
  })  : _httpClient = httpClient ?? http.Client(),
        _baseUrl =
            (baseUrl ?? ApiConfig.baseUrl).replaceFirst(RegExp(r'/$'), ''),
        _tokenProvider = tokenProvider;

  final http.Client _httpClient;
  final String _baseUrl;
  final TokenProvider? _tokenProvider;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
    bool authenticated = true,
  }) {
    return _send(
      'GET',
      path,
      queryParameters: queryParameters,
      authenticated: authenticated,
    );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) {
    return _send(
      'POST',
      path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) {
    return _send(
      'PUT',
      path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) {
    return _send(
      'DELETE',
      path,
      body: body,
      authenticated: authenticated,
    );
  }

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final headers = await _buildHeaders(authenticated: authenticated);
    final encodedBody = body == null ? null : jsonEncode(body);

    try {
      final response = await _request(method, uri, headers, encodedBody)
          .timeout(ApiConfig.timeout);
      return _decodeResponse(response);
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException(
        'Tidak bisa terhubung ke server. Periksa koneksi atau alamat API.',
      );
    } on TimeoutException {
      throw const ApiException(
        'Koneksi ke server terlalu lama. Coba lagi sebentar.',
      );
    } on FormatException {
      throw const ApiException('Format respons server belum valid.');
    }
  }

  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$_baseUrl$normalizedPath');
    return queryParameters == null
        ? uri
        : uri.replace(queryParameters: queryParameters);
  }

  Future<Map<String, String>> _buildHeaders({
    required bool authenticated,
  }) async {
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final tokenProvider = _tokenProvider;
    if (authenticated && tokenProvider != null) {
      final token = await tokenProvider();
      if (token != null && token.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> _request(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? encodedBody,
  ) {
    switch (method) {
      case 'GET':
        return _httpClient.get(uri, headers: headers);
      case 'POST':
        return _httpClient.post(uri, headers: headers, body: encodedBody);
      case 'PUT':
        return _httpClient.put(uri, headers: headers, body: encodedBody);
      case 'DELETE':
        return _httpClient.delete(uri, headers: headers, body: encodedBody);
      default:
        throw ApiException('Metode API $method belum didukung.');
    }
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final body = response.body.trim().isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException(
      _readErrorMessage(body),
      statusCode: response.statusCode,
      fieldErrors: _readFieldErrors(body),
    );
  }

  String _readErrorMessage(Map<String, dynamic> body) {
    final message = body['message'] ?? body['error'];
    if (message is String && message.trim().isNotEmpty) return message;
    return 'Permintaan ke server gagal. Coba lagi.';
  }

  Map<String, List<String>> _readFieldErrors(Map<String, dynamic> body) {
    final rawErrors = body['errors'];
    if (rawErrors is! Map<String, dynamic>) return const {};

    return rawErrors.map((key, value) {
      if (value is List) {
        return MapEntry(key, value.map((item) => item.toString()).toList());
      }
      return MapEntry(key, [value.toString()]);
    });
  }
}
