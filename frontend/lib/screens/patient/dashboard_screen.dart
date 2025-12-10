import 'package:flutter/material.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../theme/app_theme.dart';
import '../../models/analysis.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onAnalysisClick;
  final VoidCallback? onHistoryClick;

  const DashboardScreen({
    super.key,
    this.onAnalysisClick,
    this.onHistoryClick,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data - in real app, fetch from service
    final lastAnalysis = Analysis(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 0)),
      symptoms: 'Toux légère, fatigue',
      categories: ['🤧 Toux', '😴 Fatigue'],
      severity: SeverityLevel.low,
      diagnosis: 'Probable infection virale bénigne',
    );

    final notifications = [
      {
        'type': 'info',
        'message': 'Rappel: Buvez de l\'eau régulièrement',
        'read': false,
      },
      {
        'type': 'alert',
        'message': 'Surveillez votre température',
        'read': false,
      },
      {
        'type': 'info',
        'message': 'Analyse précédente mise à jour',
        'read': true,
      },
    ];

    final unreadCount = notifications.where((n) => n['read'] == false).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Section
        const Text(
          'Bienvenue sur votre espace santé',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Suivez votre santé avec l\'aide de l\'intelligence artificielle',
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Last Analysis Card
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dernière analyse IA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  _buildSeverityBadge(lastAnalysis.severity),
                ],
              ),
              const SizedBox(height: 20),
              _buildAnalysisItem('Date:', lastAnalysis.formattedDate),
              _buildAnalysisItem('Symptômes:', lastAnalysis.symptoms),
              _buildAnalysisItem('Diagnostic:', lastAnalysis.diagnosis ?? ''),
              const SizedBox(height: 20),
              AppButton(
                text: 'Voir l\'historique complet',
                onPressed: onHistoryClick,
                isPrimary: false,
                width: double.infinity,
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Action Section
        AppButton(
          text: '📊 Faire une nouvelle analyse',
          onPressed: onAnalysisClick,
          width: double.infinity,
        ),
        const SizedBox(height: 32),

        // Notifications Preview
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications récentes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (unreadCount > 0)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ...notifications.take(3).map((notif) => _buildNotificationItem(
                    notif['message'] as String,
                    notif['type'] as String,
                    notif['read'] as bool,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityBadge(SeverityLevel severity) {
    Color bgColor;
    Color textColor;
    String label;

    switch (severity) {
      case SeverityLevel.low:
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        label = 'Faible';
        break;
      case SeverityLevel.medium:
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFB45309);
        label = 'Moyen';
        break;
      case SeverityLevel.high:
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFF991B1B);
        label = 'Élevé';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAnalysisItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String message, String type, bool read) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: read ? Colors.white : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: read
                ? Colors.grey.shade300
                : AppTheme.primary,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            type == 'alert' ? '⚠️' : 'ℹ️',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

