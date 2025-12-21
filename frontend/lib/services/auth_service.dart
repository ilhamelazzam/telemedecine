import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'api_config.dart';
import 'http_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Login
  Future<User> login(String email, String password) async {
    // Mode démo : utiliser des données mockées
    if (ApiConfig.useDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      final demoUser = User(
        id: const Uuid().v4(),
        email: email,
        firstName: 'Utilisateur',
        lastName: 'Démo',
        token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _saveToken(demoUser.token!);
      await _saveUser(demoUser);
      return demoUser;
    }

    try {
      final data = await HttpService.post(
        ApiConfig.loginEndpoint,
        {
          'email': email,
          'password': password,
        },
      );

      final user = User.fromJson(data);

      // Save token and user data
      if (user.token != null) {
        await _saveToken(user.token!);
        await _saveUser(user);
      }

      return user;
    } catch (e) {
      throw Exception('Connexion échouée: ${e.toString()}');
    }
  }

  // Register
  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phone,
    String? address,
    String? region,
  }) async {
    // Mode démo : utiliser des données mockées
    if (ApiConfig.useDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      final demoUser = User(
        id: const Uuid().v4(),
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        region: region,
        token: 'demo_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await _saveToken(demoUser.token!);
      await _saveUser(demoUser);
      return demoUser;
    }

    try {
      final data = await HttpService.post(
        ApiConfig.registerEndpoint,
        {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
          if (address != null) 'address': address,
          if (region != null) 'region': region,
        },
      );

      final user = User.fromJson(data);

      if (user.token != null) {
        await _saveToken(user.token!);
        await _saveUser(user);
      }

      return user;
    } catch (e) {
      throw Exception('Inscription échouée: ${e.toString()}');
    }
  }

  // Request password reset
  Future<String> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.resetPasswordRequestEndpoint),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        final error = response.body.isNotEmpty
            ? jsonDecode(response.body)['message'] ?? response.body
            : 'Échec de la demande de réinitialisation';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Erreur lors de la demande: ${e.toString()}');
    }
  }

  // Verify reset code
  Future<void> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.verifyCodeEndpoint),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      if (response.statusCode != 200) {
        final error = response.body.isNotEmpty
            ? jsonDecode(response.body)['message'] ?? response.body
            : 'Code invalide';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Erreur lors de la vérification: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.resetPasswordEndpoint),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          'email': email,
          'code': code,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final error = response.body.isNotEmpty
            ? jsonDecode(response.body)['message'] ?? response.body
            : 'Échec de la réinitialisation';
        throw Exception(error);
      }
    } catch (e) {
      throw Exception('Erreur lors de la réinitialisation: ${e.toString()}');
    }
  }

  // Get current token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Private methods
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
