import 'package:flutter/material.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../models/analysis.dart';
import '../../theme/app_theme.dart';

class ResultsScreen extends StatefulWidget {
  final Analysis? analysis;
  final VoidCallback? onSave;
  final VoidCallback? onBack;

  const ResultsScreen({
    super.key,
    this.analysis,
    this.onSave,
    this.onBack,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _saved = false;
  bool _isLoading = false;

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _saved = true;
      _isLoading = false;
    });

    if (widget.onSave != null) {
      widget.onSave!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final analysis = widget.analysis;

    if (analysis == null) {
      return const Center(
        child: Text('Aucune analyse disponible'),
      );
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Résultat de l\'analyse IA',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onBack,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Alert Banner
              if (_saved)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.success.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.success),
                      const SizedBox(width: 8),
                      const Text(
                        'Analyse enregistrée dans votre historique',
                        style: TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Summary Section
              const Text(
                'Résumé de vos symptômes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: analysis.categories.map((cat) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Severity Level
              const Text(
                'Niveau de gravité',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildSeverityMeter(analysis.severity),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 140,
                    child: Text(
                      analysis.severityLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Diagnosis
              const Text(
                'Diagnostic préliminaire',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  border: Border(
                    left: BorderSide(
                      color: AppTheme.primary,
                      width: 4,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  analysis.diagnosis ??
                      'Sur la base de vos symptômes, une infection virale bénigne est probable. Cependant, veuillez consulter un professionnel de santé pour un diagnostic certain.',
                  style: const TextStyle(
                    color: Color(0xFF0C4A6E),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recommendations
              const Text(
                'Recommandations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...(analysis.recommendations.isNotEmpty
                  ? analysis.recommendations
                  : [
                      'Reposez-vous suffisamment (7-8 heures de sommeil)',
                      'Hydratez-vous régulièrement',
                      'Surveillez votre température',
                      'Consultez un médecin si les symptômes s\'aggravent',
                    ]).map((rec) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFBFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(
                          color: AppTheme.success,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      rec,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
              const SizedBox(height: 24),

              // Caution
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  border: Border(
                    left: BorderSide(
                      color: AppTheme.warning,
                      width: 4,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ Informations importantes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cette analyse est fournie à titre informatif seulement et ne remplace pas l\'avis d\'un professionnel de santé qualifié. En cas de doute, consultez immédiatement un médecin ou appelez les services d\'urgence.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF92400E),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: _isLoading
                          ? '⏳ Enregistrement...'
                          : _saved
                              ? '✓ Enregistré'
                              : '💾 Enregistrer',
                      onPressed: _saved ? null : _handleSave,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      text: 'Retour',
                      onPressed: widget.onBack,
                      isPrimary: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityMeter(SeverityLevel severity) {
    double width;
    Color color;

    switch (severity) {
      case SeverityLevel.low:
        width = 0.3;
        color = AppTheme.severityLow;
        break;
      case SeverityLevel.medium:
        width = 0.6;
        color = AppTheme.severityMedium;
        break;
      case SeverityLevel.high:
        width = 1.0;
        color = AppTheme.severityHigh;
        break;
    }

    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: width,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}



