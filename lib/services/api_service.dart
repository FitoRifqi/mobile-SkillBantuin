import 'package:dio/dio.dart';

import 'token_service.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );

  ApiService({
    TokenService? tokenService,
    Dio? dio,
  })  : _tokenService = tokenService ?? const TokenService(),
        dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                headers: const {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            ) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final TokenService _tokenService;
  final Dio dio;
}
