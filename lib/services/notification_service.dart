import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

/// Service for managing local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database
    tz.initializeTimeZones();

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - could navigate to review screen
    // print('Notification tapped: ${response.payload}');
  }

  /// Request notification permission (Android 13+)
  Future<bool> requestPermission() async {
    if (!_initialized) {
      await initialize();
    }

    // For Android 13+ (API 33+), we need to request permission
    final status = await Permission.notification.request();
    
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // Permission denied, but can request again
      return false;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open settings
      await openAppSettings();
      return false;
    }
    
    return false;
  }

  /// Check if notification permission is granted
  Future<bool> hasPermission() async {
    if (!_initialized) {
      await initialize();
    }

    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Schedule a daily notification at a specific time
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    // Check permission first
    final hasPermission = await this.hasPermission();
    if (!hasPermission) {
      // print('Notification permission not granted');
      return;
    }

    // Cancel any existing notifications
    await cancelAllNotifications();

    // Create notification time for today
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time is in the past, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Daily Review Reminder',
      channelDescription: 'Daily reminder to review your flashcards',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    // iOS notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule the notification to repeat daily
    await _notifications.zonedSchedule(
      0, // Notification ID
      '📚 Time to Review!',
      'Keep your learning streak going. Review your flashcards now.',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily at same time
    );

    // print('Daily notification scheduled for ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');
  }

  /// Send an immediate test notification
  Future<void> sendTestNotification() async {
    if (!_initialized) {
      await initialize();
    }

    // Check permission first
    final hasPermission = await this.hasPermission();
    if (!hasPermission) {
      // print('Notification permission not granted');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'test_notification',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999, // Notification ID for test
      '✅ Notifications Working!',
      'You will receive daily reminders at your scheduled time.',
      notificationDetails,
    );
  }

  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    if (!_initialized) {
      await initialize();
    }
    await _notifications.cancelAll();
    // print('All notifications cancelled');
  }

  /// Check if notifications are scheduled
  Future<bool> hasScheduledNotifications() async {
    if (!_initialized) {
      await initialize();
    }
    final pending = await _notifications.pendingNotificationRequests();
    return pending.isNotEmpty;
  }

  /// Get scheduled notification time (if any)
  Future<Map<String, int>?> getScheduledTime() async {
    if (!_initialized) {
      await initialize();
    }
    
    final pending = await _notifications.pendingNotificationRequests();
    if (pending.isEmpty) return null;
    
    // This is a simplified version - in a real app, you'd store the time in shared preferences
    // For now, we'll return null and rely on the UI to track the time
    return null;
  }
}
