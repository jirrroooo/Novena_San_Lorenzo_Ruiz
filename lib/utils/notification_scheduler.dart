import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:novena_lorenzo/main.dart';
import 'package:novena_lorenzo/utils/log_service.dart';
import 'package:novena_lorenzo/utils/permission_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotifications() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isScheduled = prefs.getBool('isScheduled') ?? false;
  int year = prefs.getInt('year') ?? 2000;

  if (isScheduled && year == DateTime.now().year) {
    return;
  }

  if (await requestNotificationPermission() == false) {
    return;
  }

  try {
    // Initialize timezone
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    final now = DateTime.now();

    // 1. Schedule notification for every 28th of the month
    for (int month = 1; month <= 12; month++) {
      final scheduledDate = DateTime(now.year, month, 28, 9, 0); // 9:00 AM
      if (scheduledDate.isAfter(now)) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          month, // Unique ID for this notification
          '✙ Today is Devotion Day!',
          'Pray the Perpetual Novena to St. Lorenzo Ruiz on the App 😇🙏',
          tz.TZDateTime.from(scheduledDate, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'monthly_channel',
              'Monthly Notifications',
              channelDescription: 'Notifications for the 28th of each month',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }

    // 2. Schedule notifications for September 19–28
    if (now.year <= DateTime.now().year) {
      int counter = 0;
      for (int day = 19; day < 28; day++) {
        counter++;
        final scheduledDate = DateTime(now.year, 9, day, 8, 0); // 8:00 AM
        if (scheduledDate.isAfter(now)) {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            1000 + day, // Unique ID for this notification
            '✙ Novena Day $counter',
            'Pray the Novena to St. Lorenzo Ruiz on the App 😇🙏',
            tz.TZDateTime.from(scheduledDate, tz.local),
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'september_channel',
                'September Notifications',
                channelDescription: 'Notifications for September 19–28',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),

            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        }
      }
    }

    final scheduledDate = DateTime(now.year, 9, 28, 6, 0); // 6:00 AM
    if (scheduledDate.isAfter(now)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        28, // Unique ID for this notification
        'Happy Feast Day! 🎉🎊',
        'Sing or play the hymn to St. Lorenzo Ruiz on the app 😇🙏',
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'september_channel',
            'September Notifications',
            channelDescription: 'Notifications for September 19–28',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),

        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    await prefs.setBool('isScheduled', true);
    await prefs.setInt('year', DateTime.now().year);
  } catch (e) {
    LogService().logError(e.toString());
  }
}
