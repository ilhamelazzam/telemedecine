class ApiConfig {
  // Changez cette URL selon votre backend
  static const String baseUrl = 'http://localhost:8080/api';
  // Alternative: 'http://localhost:4000'
  
  // Mode démo : activez ceci pour utiliser des données mockées
  static const bool useDemoMode = true; // Mettez à false pour utiliser le vrai backend

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String resetPasswordRequestEndpoint = '$baseUrl/auth/reset-request';
  static const String verifyCodeEndpoint = '$baseUrl/auth/verify-code';
  static const String resetPasswordEndpoint = '$baseUrl/auth/reset-password';

  // Analysis endpoints
  static const String analysisEndpoint = '$baseUrl/analysis';
  static const String analysisHistoryEndpoint = '$baseUrl/analysis/history';

  // Profile endpoints
  static const String profileEndpoint = '$baseUrl/profile';

  // Notification endpoints
  static const String notificationsEndpoint = '$baseUrl/notifications';

  // Headers
  static Map<String, String> getHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
}

