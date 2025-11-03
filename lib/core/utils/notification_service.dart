import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize local timezone
    await _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
      },
    );

    await requestPermissions();
  }

  static Future<void> _configureLocalTimeZone() async {
    tz_data.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    print('Local timezone set to: $timeZoneName');
  }

  static Future<void> requestPermissions() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      print('Notification permission: $status');
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isDenied) {
        print('⚠️ Exact alarm permission denied - notifications may not work!');
      } else {
        print('✅ Exact alarm permission granted');
      }
    }
  }

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? quote,
  }) async {
    final String notificationBody = quote != null ? '$body\n\n"$quote"' : body;

    await _notifications.show(
      id,
      title,
      notificationBody,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notifications',
          'Instant Notifications',
          channelDescription: 'Instant test notifications',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(notificationBody),
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'instant_test',
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? quote,
  }) async {
    final String notificationBody = quote != null ? '$body\n\n"$quote"' : body;

    // Convert to TZDateTime
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    final now = tz.TZDateTime.now(tz.local);

    print('═══════════════════════════════════');
    print(' Scheduling notification:');
    print('   ID: $id');
    print('   Title: $title');
    print('   Scheduled for: $scheduledDate');
    print('   Current time: $now');
    print('   Time difference: ${scheduledDate.difference(now).inMinutes} minutes');
    print('═══════════════════════════════════');

    await _notifications.zonedSchedule(
      id,
      title,
      notificationBody,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit Reminders',
          channelDescription: 'Daily habit reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(notificationBody),
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await debugPrintPendingNotifications();
  }

  static Future<void> debugPrintPendingNotifications() async {
    final pendingNotifications =
    await _notifications.pendingNotificationRequests();

    if (pendingNotifications.isEmpty) {
      print('⚠ No pending notifications');
      return;
    }

    print('══════ Pending Notifications (${pendingNotifications.length}) ══════');
    for (final notification in pendingNotifications) {
      print('''
     ID: ${notification.id}
     Title: ${notification.title}
     Body: ${notification.body}
''');
    }
    print('═══════════════════════════════════');
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    print(' Cancelled notification with ID: $id');
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print(' All notifications cancelled');
  }
}
