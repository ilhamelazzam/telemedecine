import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class HttpService {
  /// Generic GET request
  static Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      print('🔵 GET Request: $endpoint'); // Debug log

      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: ApiConfig.getHeaders(token: token),
          )
          .timeout(const Duration(seconds: 30));

      print('🔵 Response Status: ${response.statusCode}'); // Debug log
      return _handleResponse(response);
    } on SocketException catch (e) {
      print('❌ SocketException: $e'); // Debug log
      throw Exception(
          'Impossible de se connecter au serveur. Vérifiez que le backend est démarré sur le port 8081.');
    } on HttpException catch (e) {
      print('❌ HttpException: $e'); // Debug log
      throw Exception('Erreur de communication avec le serveur.');
    } on FormatException catch (e) {
      print('❌ FormatException: $e'); // Debug log
      throw Exception('Réponse invalide du serveur.');
    } on TimeoutException catch (e) {
      print('❌ TimeoutException: $e'); // Debug log
      throw Exception('Le serveur ne répond pas. Vérifiez votre connexion.');
    } catch (e) {
      print('❌ Unexpected Error: $e'); // Debug log
      throw Exception('Erreur inattendue: $e');
    }
  }

  /// Generic POST request
  static Future<dynamic> post(String endpoint, dynamic body,
      {String? token}) async {
    try {
      print('🔵 POST Request: $endpoint'); // Debug log
      print('🔵 Request Body: ${jsonEncode(body)}'); // Debug log

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: ApiConfig.getHeaders(token: token),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      print('🔵 Response Status: ${response.statusCode}'); // Debug log
      return _handleResponse(response);
    } on SocketException catch (e) {
      print('❌ SocketException: $e'); // Debug log
      throw Exception(
          'Impossible de se connecter au serveur. Vérifiez que le backend est démarré sur le port 8081.');
    } on HttpException catch (e) {
      print('❌ HttpException: $e'); // Debug log
      throw Exception('Erreur de communication avec le serveur.');
    } on FormatException catch (e) {
      print('❌ FormatException: $e'); // Debug log
      throw Exception('Réponse invalide du serveur.');
    } on TimeoutException catch (e) {
      print('❌ TimeoutException: $e'); // Debug log
      throw Exception('Le serveur ne répond pas. Vérifiez votre connexion.');
    } catch (e) {
      print('❌ Unexpected Error: $e'); // Debug log
      throw Exception('Erreur inattendue: $e');
    }
  }

  /// Generic PUT request
  static Future<dynamic> put(String endpoint, dynamic body,
      {String? token}) async {
    try {
      final response = await http
          .put(
            Uri.parse(endpoint),
            headers: ApiConfig.getHeaders(token: token),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Aucune connexion Internet. Vérifiez votre réseau.');
    } on HttpException {
      throw Exception('Erreur de communication avec le serveur.');
    } on FormatException {
      throw Exception('Réponse invalide du serveur.');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  /// Generic DELETE request
  static Future<dynamic> delete(String endpoint, {String? token}) async {
    try {
      final response = await http
          .delete(
            Uri.parse(endpoint),
            headers: ApiConfig.getHeaders(token: token),
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Aucune connexion Internet. Vérifiez votre réseau.');
    } on HttpException {
      throw Exception('Erreur de communication avec le serveur.');
    } on FormatException {
      throw Exception('Réponse invalide du serveur.');
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  /// Handle HTTP response
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isEmpty) {
          return {};
        }
        return jsonDecode(response.body);
      case 400:
        throw Exception('Requête invalide: ${_extractErrorMessage(response)}');
      case 401:
        throw Exception('Non autorisé. Veuillez vous reconnecter.');
      case 403:
        throw Exception('Accès interdit.');
      case 404:
        throw Exception('Ressource non trouvée.');
      case 500:
      case 502:
      case 503:
        throw Exception('Erreur serveur. Veuillez réessayer plus tard.');
      default:
        throw Exception('Erreur HTTP ${response.statusCode}');
    }
  }

  /// Extract error message from response
  static String _extractErrorMessage(http.Response response) {
    try {
      if (response.body.isEmpty) {
        return 'Erreur inconnue';
      }

      final data = jsonDecode(response.body);

      if (data is String) {
        return data;
      }

      if (data is Map) {
        return data['message'] ?? data['error'] ?? 'Erreur inconnue';
      }

      return 'Erreur inconnue';
    } catch (e) {
      return response.body;
    }
  }
}
