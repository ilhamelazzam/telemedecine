class ApiConfig {
  // Changez cette URL selon votre backend
  // Pour émulateur Android: 'http://10.0.2.2:8080/api'
  // Pour appareil physique sur même réseau: 'http://192.168.X.X:8080/api'
  // Pour localhost: 'http://localhost:8080/api'
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // Mode démo : activez ceci pour utiliser des données mockées
  static const bool useDemoMode = false; // Mettez à false pour utiliser le vrai backend

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

