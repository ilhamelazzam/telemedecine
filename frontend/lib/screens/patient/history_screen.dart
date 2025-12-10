import 'package:flutter/material.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../services/analysis_service.dart';
import '../../models/analysis.dart';
import '../../theme/app_theme.dart';

enum SortBy { date, severity }

class HistoryScreen extends StatefulWidget {
  final Function(Analysis)? onSelectAnalysis;
  final VoidCallback? onNewAnalysis;

  const HistoryScreen({
    super.key,
    this.onSelectAnalysis,
    this.onNewAnalysis,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _analysisService = AnalysisService();
  List<Analysis> _analyses = [];
  SortBy _sortBy = SortBy.date;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final analyses = await _analysisService.getAnalysisHistory();
      setState(() {
        _analyses = analyses;
        _sortAnalyses();
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _sortAnalyses() {
    setState(() {
      if (_sortBy == SortBy.date) {
        _analyses.sort((a, b) => b.date.compareTo(a.date));
      } else {
        final severityOrder = {
          SeverityLevel.high: 3,
          SeverityLevel.medium: 2,
          SeverityLevel.low: 1,
        };
        _analyses.sort((a, b) =>
            severityOrder[b.severity]!.compareTo(severityOrder[a.severity]!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historique de vos analyses',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Consultez toutes vos analyses précédentes',
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Sort Controls
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Trier par:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<SortBy>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(
                    value: SortBy.date,
                    child: Text('Date (plus récente)'),
                  ),
                  DropdownMenuItem(
                    value: SortBy.severity,
                    child: Text('Gravité'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _sortBy = value;
                      _sortAnalyses();
                    });
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Analyses List
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (_analyses.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: Text(
                'Aucune analyse disponible',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          )
        else
          ..._analyses.map((analysis) => _buildAnalysisCard(analysis)),
        const SizedBox(height: 24),

        // New Analysis Button
        AppButton(
          text: '+ Nouvelle analyse',
          onPressed: widget.onNewAnalysis,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(Analysis analysis) {
    return AppCard(
      onTap: () {
        if (widget.onSelectAnalysis != null) {
          widget.onSelectAnalysis!(analysis);
        }
      },
      child: Row(
        children: [
          Text(
            analysis.severityEmoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  analysis.formattedDate,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  analysis.symptoms,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            analysis.severityLabel,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}



