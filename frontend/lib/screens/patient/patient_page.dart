import 'package:flutter/material.dart';
import 'patient_navigation.dart';
import 'dashboard_screen.dart';
import 'symptom_analysis_screen.dart';
import 'results_screen.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import '../../models/analysis.dart';
import 'patient_screen.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  PatientScreen _currentScreen = PatientScreen.dashboard;
  Analysis? _currentAnalysis;
  Analysis? _selectedAnalysis;

  void _handleScreenChange(PatientScreen screen) {
    setState(() => _currentScreen = screen);
  }

  void _handleAnalysisSubmit(Analysis analysis) {
    setState(() {
      _currentAnalysis = analysis;
      _currentScreen = PatientScreen.results;
    });
  }

  void _handleResultsSave() {
    // After saving, return to dashboard
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentScreen = PatientScreen.dashboard;
          _currentAnalysis = null;
        });
      }
    });
  }

  void _handleSelectAnalysis(Analysis analysis) {
    setState(() {
      _selectedAnalysis = analysis;
      _currentScreen = PatientScreen.results;
    });
  }

  Widget _renderContent() {
    switch (_currentScreen) {
      case PatientScreen.dashboard:
        return DashboardScreen(
          onAnalysisClick: () => _handleScreenChange(PatientScreen.analysis),
          onHistoryClick: () => _handleScreenChange(PatientScreen.history),
        );
      case PatientScreen.analysis:
        return SymptomAnalysisScreen(
          onResultsReady: _handleAnalysisSubmit,
          onBack: () => _handleScreenChange(PatientScreen.dashboard),
        );
      case PatientScreen.results:
        return ResultsScreen(
          analysis: _currentAnalysis ?? _selectedAnalysis,
          onSave: _handleResultsSave,
          onBack: () => _handleScreenChange(PatientScreen.dashboard),
        );
      case PatientScreen.history:
        return HistoryScreen(
          onSelectAnalysis: _handleSelectAnalysis,
          onNewAnalysis: () => _handleScreenChange(PatientScreen.analysis),
        );
      case PatientScreen.notifications:
        return const NotificationsScreen();
      case PatientScreen.profile:
        return ProfileScreen(
          onLogout: () {
            // Handle logout
            Navigator.of(context).pushReplacementNamed('/login');
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PatientNavigation(
      currentScreen: _currentScreen,
      onScreenChange: _handleScreenChange,
      child: _renderContent(),
    );
  }
}

