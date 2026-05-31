class ApiConfig {
  const ApiConfig._();

  static const bool useLaravelApi = bool.fromEnvironment(
    'USE_LARAVEL_API',
    defaultValue: false,
  );

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static const Duration timeout = Duration(seconds: 20);
}
