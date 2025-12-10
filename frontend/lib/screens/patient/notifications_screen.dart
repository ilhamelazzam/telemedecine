import 'package:flutter/material.dart';
import '../../widgets/common/app_card.dart';
import '../../models/notification.dart' as models;
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock notifications - in real app, fetch from service
  final List<models.AppNotification> _notifications = [
    models.AppNotification(
      id: '1',
      type: models.NotificationType.info,
      title: 'Rappel de santé',
      message: 'N\'oubliez pas de boire de l\'eau régulièrement',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      read: false,
    ),
    models.AppNotification(
      id: '2',
      type: models.NotificationType.alert,
      title: 'Alerte importante',
      message: 'Surveillez votre température si la fièvre persiste',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      read: false,
    ),
    models.AppNotification(
      id: '3',
      type: models.NotificationType.success,
      title: 'Mise à jour complétée',
      message: 'Votre historique d\'analyses a été mis à jour',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      read: true,
    ),
    models.AppNotification(
      id: '4',
      type: models.NotificationType.info,
      title: 'Rappel de consultation',
      message: 'Pensez à vérifier votre suivi médical régulier',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      read: true,
    ),
  ];

  int get _unreadCount {
    return _notifications.where((n) => !n.read).length;
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(read: true);
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _unreadCount > 0
                  ? 'Vous avez $_unreadCount notification${_unreadCount > 1 ? 's' : ''} non lue${_unreadCount > 1 ? 's' : ''}'
                  : 'Aucune notification non lue',
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            if (_notifications.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Text(
                    'Aucune notification pour le moment',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ..._notifications.map((notif) => _buildNotificationCard(notif)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(models.AppNotification notif) {
    return AppCard(
      backgroundColor: notif.read ? Colors.white : const Color(0xFFF0F9FF),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notif.emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notif.message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notif.timeAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!notif.read)
                IconButton(
                  icon: const Icon(Icons.check, size: 18),
                  onPressed: () => _markAsRead(notif.id),
                  tooltip: 'Marquer comme lu',
                  color: AppTheme.textSecondary,
                ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => _deleteNotification(notif.id),
                tooltip: 'Supprimer',
                color: AppTheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

