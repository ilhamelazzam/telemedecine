import 'dart:io';

class NetworkConfig {
  // Check if running on Android Emulator
  static bool get isAndroidEmulator {
    return Platform.isAndroid;
  }

  // Check if running on iOS Simulator
  static bool get isIosSimulator {
    return Platform.isIOS;
  }

  // Get the appropriate base URL based on platform
  static String getBaseUrl() {
    if (isAndroidEmulator) {
      // Android emulator: 10.0.2.2 maps to host's localhost
      return 'http://10.0.2.2:8081/api';
    } else if (isIosSimulator) {
      // iOS simulator: localhost works directly
      return 'http://localhost:8081/api';
    } else {
      // Physical device: Use your computer's IP address
      // Replace with your actual IP address
      return 'http://192.168.1.100:8081/api';
    }
  }

  // Alternative URLs for testing
  static const String localUrl = 'http://localhost:8081/api';
  static const String emulatorUrl = 'http://10.0.2.2:8081/api';

  // Test connection to backend
  static Future<bool> testConnection() async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('${getBaseUrl()}/health'));
      final response =
          await request.close().timeout(const Duration(seconds: 5));
      await response.drain();
      client.close();
      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      return false;
    }
  }
}
