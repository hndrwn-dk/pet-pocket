import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as perm_handler;
import 'logger.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (_initialized) return;
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _initialized = true;
    Logger.info('Notifications initialized');
  }
  
  static void _onNotificationTapped(NotificationResponse response) {
    Logger.debug('Notification tapped: ${response.payload}');
  }
  
  static Future<bool> requestPermission() async {
    if (await _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled() ?? false) {
      return true;
    }
    
    final status = await perm_handler.Permission.notification.request();
    return status.isGranted;
  }
  
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'pet_pocket_channel',
      'Pet Pocket',
      channelDescription: 'Notifications for your pet',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details);
  }
  
  static Future<void> checkAndNotify({
    required double hunger,
    required double clean,
  }) async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      Logger.warning('Notification permission not granted');
      return;
    }
    
    if (hunger < 25.0) {
      await showNotification(
        id: 1,
        title: 'Pet is hungry',
        body: 'Your pet needs food!',
      );
    }
    
    if (clean < 25.0) {
      await showNotification(
        id: 2,
        title: 'Pet is dirty',
        body: 'Your pet needs cleaning!',
      );
    }
  }
}

