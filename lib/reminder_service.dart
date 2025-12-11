import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize notifications and timezone
  static Future<void> init() async {
    tzData.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);
  }

  /// Schedule a notification at a specific DateTime
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Optional: cancel a notification by id
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Optional: cancel all notifications
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
