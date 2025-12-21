import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Automatically detect the correct URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      // Web: Use localhost
      return 'http://localhost:8081/api';
    } else if (Platform.isAndroid) {
      // Android emulator: Use 10.0.2.2
      return 'http://10.0.2.2:8081/api';
    } else if (Platform.isIOS) {
      // iOS simulator: Use localhost
      return 'http://localhost:8081/api';
    } else {
      // Physical device: Change to your computer's IP
      return 'http://192.168.1.100:8081/api';
    }
  }

  // Mode démo : activez ceci pour utiliser des données mockées
  static const bool useDemoMode =
      false; // Mettez à false pour utiliser le vrai backend

  // Auth endpoints
  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get registerEndpoint => '$baseUrl/auth/register';
  static String get resetPasswordRequestEndpoint =>
      '$baseUrl/auth/reset-request';
  static String get verifyCodeEndpoint => '$baseUrl/auth/verify-code';
  static String get resetPasswordEndpoint => '$baseUrl/auth/reset-password';

  // Analysis endpoints
  static String get analysisEndpoint => '$baseUrl/analysis';
  static String get analysisHistoryEndpoint => '$baseUrl/analysis/history';

  // Profile endpoints
  static String get profileEndpoint => '$baseUrl/profile';

  // Notification endpoints
  static String get notificationsEndpoint => '$baseUrl/notifications';

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
