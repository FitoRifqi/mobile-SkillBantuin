class AppConfig {
  AppConfig._();

  // Local development URL
  static const String localBaseUrl = 'http://localhost:8000/api';

  // Android emulator URL (if needed)
  static const String emulatorBaseUrl = 'http://10.0.2.2:8000/api';

  // Production URL - replace with your AWS API Gateway or load balancer domain
  static const String productionBaseUrl = 'http://32.236.1.176:8000/api';

  static const String overrideBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (overrideBaseUrl.isNotEmpty) return overrideBaseUrl;

    return productionBaseUrl;
  }
}
