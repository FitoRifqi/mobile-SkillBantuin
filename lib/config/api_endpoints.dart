class ApiEndpoints {
  const ApiEndpoints._();

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  static const String clientTasks = '/client/tasks';
  static const String availableTasks = '/freelancer/tasks/available';
  static const String freelancerApplications = '/freelancer/applications';
  static const String freelancerWork = '/freelancer/work';

  static String task(String taskId) => '/tasks/$taskId';
  static String taskOffers(String taskId) => '/tasks/$taskId/offers';
  static String acceptOffer(String taskId, String offerId) {
    return '/tasks/$taskId/offers/$offerId/accept';
  }

  static String taskPayment(String taskId) => '/tasks/$taskId/payment';
  static String submitWorkResult(String taskId) => '/tasks/$taskId/results';
  static String reviewTask(String taskId) => '/tasks/$taskId/review';
}
