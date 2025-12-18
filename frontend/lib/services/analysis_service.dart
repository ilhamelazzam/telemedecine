import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/analysis.dart';
import '../services/auth_service.dart';
import 'api_config.dart';
import 'http_service.dart';

class AnalysisService {
  final AuthService _authService = AuthService();

  // Submit symptom analysis
  Future<Analysis> submitAnalysis({
    required String symptoms,
    required List<String> categories,
    String? imagePath,
  }) async {
    if (ApiConfig.useDemoMode) {
      await Future.delayed(const Duration(seconds: 2));
      return _createMockAnalysis(symptoms, categories);
    }

    try {
      final token = await _authService.getToken();
      
      // Prepare request body
      final body = {
        'symptoms': symptoms,
        'categories': categories,
        if (imagePath != null) 'imageUrl': imagePath,
      };

      final data = await HttpService.post(
        ApiConfig.analysisEndpoint,
        body,
        token: token,
      );

      return Analysis.fromJson(data);
    } catch (e) {
      throw Exception('Échec de l\'analyse: ${e.toString()}');
    }
  }

  // Get analysis history
  Future<List<Analysis>> getAnalysisHistory() async {
    if (ApiConfig.useDemoMode) {
      await Future.delayed(const Duration(seconds: 1));
      return _getMockHistory();
    }

    try {
      final token = await _authService.getToken();
      
      final data = await HttpService.get(
        ApiConfig.analysisHistoryEndpoint,
        token: token,
      );

      if (data is List) {
        return data.map((json) => Analysis.fromJson(json as Map<String, dynamic>)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Échec de récupération de l\'historique: ${e.toString()}');
    }
  }

  // Get single analysis
  Future<Analysis> getAnalysis(String id) async {
    if (ApiConfig.useDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockHistory = _getMockHistory();
      return mockHistory.firstWhere(
        (a) => a.id == id,
        orElse: () => mockHistory.first,
      );
    }

    try {
      final token = await _authService.getToken();
      
      final data = await HttpService.get(
        '${ApiConfig.analysisEndpoint}/$id',
        token: token,
      );

      if (data != null) {
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



