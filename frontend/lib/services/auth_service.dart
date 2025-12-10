import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'api_config.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Login
  Future<User> login(String email, String password) async {
    // Mode démo : utiliser des données mockées
    if (ApiConfig.useDemoMode) {
      await Future.delayed(const Duration(seconds: 1)); // Simuler un délai réseau
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
      final response = await http.post(
        Uri.parse(ApiConfig.loginEndpoint),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        
        // Save token and user data
        await _saveToken(user.token ?? '');
        await _saveUser(user);
        
        return user;
      } else {
        final error = response.body.isNotEmpty
            ? jsonDecode(response.body)['message'] ?? response.body
            : 'Échec de la connexion';
        throw Exception(error);
      }
    } catch (e) {
      // Si le backend n'est pas disponible, utiliser le mode démo
      if (e.toString().contains('Failed to fetch') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('TimeoutException')) {
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
      throw Exception('Erreur lors de la connexion: ${e.toString()}');
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
      await Future.delayed(const Duration(seconds: 1)); // Simuler un délai réseau
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
      final response = await http.post(
        Uri.parse(ApiConfig.registerEndpoint),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          'fullName': '$firstName $lastName'.trim(),
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
          'region': region,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        
        if (user.token != null) {
          await _saveToken(user.token!);
          await _saveUser(user);
        }
        
        return user;
      } else {
        final error = response.body.isNotEmpty
            ? jsonDecode(response.body)['message'] ?? response.body
            : 'Échec de l\'inscription';
        throw Exception(error);
      }
    } catch (e) {
      // Si le backend n'est pas disponible, utiliser le mode démo
      if (e.toString().contains('Failed to fetch') || 
          e.toString().contains('Connection refused') ||
          e.toString().contains('TimeoutException')) {
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
      throw Exception('Erreur lors de l\'inscription: ${e.toString()}');
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

