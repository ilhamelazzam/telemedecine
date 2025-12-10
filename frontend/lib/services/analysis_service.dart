import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/analysis.dart';
import '../services/auth_service.dart';
import 'api_config.dart';

class AnalysisService {
  final AuthService _authService = AuthService();

  // Submit symptom analysis
  Future<Analysis> submitAnalysis({
    required String symptoms,
    required List<String> categories,
    String? imagePath,
  }) async {
    try {
      final token = await _authService.getToken();
      
      // Prepare form data or JSON
      final body = {
        'symptoms': symptoms,
        'categories': categories,
        if (imagePath != null) 'imageUrl': imagePath,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.analysisEndpoint),
        headers: ApiConfig.getHeaders(token: token),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Analysis.fromJson(data);
      } else {
        // For demo purposes, return a mock analysis
        return _createMockAnalysis(symptoms, categories);
      }
    } catch (e) {
      // For demo purposes, return a mock analysis
      return _createMockAnalysis(symptoms, categories);
    }
  }

  // Get analysis history
  Future<List<Analysis>> getAnalysisHistory() async {
    try {
      final token = await _authService.getToken();
      
      final response = await http.get(
        Uri.parse(ApiConfig.analysisHistoryEndpoint),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((json) => Analysis.fromJson(json)).toList();
        }
      }
      
      // Return mock data for demo
      return _getMockHistory();
    } catch (e) {
      // Return mock data for demo
      return _getMockHistory();
    }
  }

  // Get single analysis
  Future<Analysis> getAnalysis(String id) async {
    try {
      final token = await _authService.getToken();
      
      final response = await http.get(
        Uri.parse('${ApiConfig.analysisEndpoint}/$id'),
        headers: ApiConfig.getHeaders(token: token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Analysis.fromJson(data);
      } else {
        throw Exception('Analyse non trouvée');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération: ${e.toString()}');
    }
  }

  // Mock data methods (for demo when API is not available)
  Analysis _createMockAnalysis(String symptoms, List<String> categories) {
    final now = DateTime.now();
    return Analysis(
      id: const Uuid().v4(),
      date: now,
      symptoms: symptoms,
      categories: categories,
      severity: SeverityLevel.low,
      diagnosis: 'Sur la base de vos symptômes, une infection virale bénigne est probable. Cependant, veuillez consulter un professionnel de santé pour un diagnostic certain.',
      recommendations: [
        'Reposez-vous suffisamment (7-8 heures de sommeil)',
        'Hydratez-vous régulièrement',
        'Surveillez votre température',
        'Consultez un médecin si les symptômes s\'aggravent',
      ],
    );
  }

  List<Analysis> _getMockHistory() {
    final now = DateTime.now();
    return [
      Analysis(
        id: const Uuid().v4(),
        date: now.subtract(const Duration(days: 0)),
        symptoms: 'Toux légère, fatigue',
        categories: ['🤧 Toux', '😴 Fatigue'],
        severity: SeverityLevel.low,
        diagnosis: 'Probable infection virale bénigne',
      ),
      Analysis(
        id: const Uuid().v4(),
        date: now.subtract(const Duration(days: 3)),
        symptoms: 'Mal à la gorge, fièvre',
        categories: ['🌡️ Fièvre'],
        severity: SeverityLevel.medium,
      ),
      Analysis(
        id: const Uuid().v4(),
        date: now.subtract(const Duration(days: 6)),
        symptoms: 'Douleur dorsale, fatigue extrême',
        categories: ['🤕 Douleur', '😴 Fatigue'],
        severity: SeverityLevel.high,
      ),
      Analysis(
        id: const Uuid().v4(),
        date: now.subtract(const Duration(days: 11)),
        symptoms: 'Légers symptômes de rhume',
        categories: ['🤧 Toux'],
        severity: SeverityLevel.low,
      ),
    ];
  }
}



