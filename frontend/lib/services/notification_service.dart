import '../models/notification.dart' as models;
import '../services/auth_service.dart';
import 'api_config.dart';
import 'http_service.dart';

class NotificationService {
  final AuthService _authService = AuthService();

  // Get all notifications
  Future<List<models.AppNotification>> getNotifications() async {
    try {
      final token = await _authService.getToken();
      
      final data = await HttpService.get(
        ApiConfig.notificationsEndpoint,
        token: token,
      );

      if (data is List) {
        return data.map((json) => models.AppNotification.fromJson(json as Map<String, dynamic>)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ NotificationService.getNotifications error: $e');
      throw Exception('Failed to load notifications: ${e.toString()}');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await _authService.getToken();
      
      await HttpService.put(
        '${ApiConfig.notificationsEndpoint}/$notificationId/read',
        {},
        token: token,
      );
    } catch (e) {
      print('❌ NotificationService.markAsRead error: $e');
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final token = await _authService.getToken();
      
      await HttpService.delete(
        '${ApiConfig.notificationsEndpoint}/$notificationId',
        token: token,
      );
    } catch (e) {
      print('❌ NotificationService.deleteNotification error: $e');
      throw Exception('Failed to delete notification: ${e.toString()}');
    }
  }
}
