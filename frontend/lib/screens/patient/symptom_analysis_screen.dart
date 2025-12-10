import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_input.dart';
import '../../services/analysis_service.dart';
import '../../models/analysis.dart';
import '../../theme/app_theme.dart';

class SymptomAnalysisScreen extends StatefulWidget {
  final Function(Analysis)? onResultsReady;
  final VoidCallback? onBack;

  const SymptomAnalysisScreen({
    super.key,
    this.onResultsReady,
    this.onBack,
  });

  @override
  State<SymptomAnalysisScreen> createState() => _SymptomAnalysisScreenState();
}

class _SymptomAnalysisScreenState extends State<SymptomAnalysisScreen> {
  final _symptomsController = TextEditingController();
  final _analysisService = AnalysisService();
  final List<String> _selectedCategories = [];
  String? _imagePath;
  bool _isLoading = false;

  final List<String> _categories = [
    '🌡️ Fièvre',
    '🤧 Toux',
    '🤕 Douleur',
    '😴 Fatigue',
    '🤢 Nausée',
    '😤 Essoufflement',
  ];

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  Future<void> _handleAnalyze() async {
    if (_symptomsController.text.trim().isEmpty && _selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez décrire vos symptômes ou sélectionner une catégorie'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final analysis = await _analysisService.submitAnalysis(
        symptoms: _symptomsController.text.trim(),
        categories: _selectedCategories,
        imagePath: _imagePath,
      );

      if (mounted && widget.onResultsReady != null) {
        widget.onResultsReady!(analysis);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Décrivez vos symptômes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Fournissez autant de détails que possible pour une meilleure analyse',
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Symptom Description
        AppInput(
          label: 'DESCRIPTION DE VOS SYMPTÔMES',
          hint: 'Ex: Toux depuis 3 jours, mal à la gorge, légère fièvre...',
          controller: _symptomsController,
          maxLines: 5,
        ),
        const SizedBox(height: 24),

        // Categories
        const Text(
          'CATÉGORIES DE SYMPTÔMES',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((category) {
            final isSelected = _selectedCategories.contains(category);
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => _toggleCategory(category),
              selectedColor: AppTheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Image Upload
        const Text(
          'AJOUTER UNE IMAGE (OPTIONNEL)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFAFAFC),
            ),
            child: Column(
              children: [
                Icon(
                  _imagePath != null ? Icons.check_circle : Icons.camera_alt,
                  size: 48,
                  color: _imagePath != null ? AppTheme.success : AppTheme.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  _imagePath != null
                      ? 'Image sélectionnée: ${_imagePath!.split('/').last}'
                      : '📷 Cliquez pour ajouter une image',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Analyze Button
        AppButton(
          text: _isLoading ? '⏳ Analyse en cours...' : '🔬 Analyser avec l\'IA',
          onPressed: _handleAnalyze,
          isLoading: _isLoading,
          width: double.infinity,
        ),
      ],
    );
  }
}

