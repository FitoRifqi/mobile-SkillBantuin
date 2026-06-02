class AppConfig {
  AppConfig._();

  // Local development URL
  static const String localBaseUrl = 'http://localhost:8000/api';

  // Android emulator URL (if needed)
  static const String emulatorBaseUrl = 'http://10.0.2.2:8000/api';

  // Production URL - replace with your AWS API Gateway or load balancer domain
  static const String productionBaseUrl = 'https://YOUR_AWS_DOMAIN/api';

  static String get baseUrl {
    return const bool.fromEnvironment('dart.vm.product')
        ? productionBaseUrl
        : localBaseUrl;
  }
}
