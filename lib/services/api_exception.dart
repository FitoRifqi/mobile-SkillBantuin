class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  const ApiException(
    this.message, {
    this.statusCode,
    this.fieldErrors = const {},
  });

  bool get isValidationError => statusCode == 422 && fieldErrors.isNotEmpty;

  @override
  String toString() => message;
}
