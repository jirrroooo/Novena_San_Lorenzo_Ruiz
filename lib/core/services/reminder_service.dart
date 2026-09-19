import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules the devotional reminders:
///
/// * every 28th of the month at 9:00 AM (perpetual novena / devotion day),
/// * every September 19–27 at 8:00 AM (the nine days of the novena),
/// * every September 28 at 6:00 AM (feast day).
///
/// All reminders repeat on their own, so they keep working in later years even
/// if the app is not opened. Inexact alarms are used on purpose: reminders do
/// not need second-level precision and exact alarms require a restricted
/// Play Store permission.
class ReminderService {
  ReminderService._();

  static final ReminderService instance = ReminderService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _monthlyId = 1;
  static const _feastId = 28;
  static const _novenaBaseId = 1000; // + day of month (1019–1027)

  static const _monthlyChannel = AndroidNotificationDetails(
    'monthly_channel',
    'Monthly devotion',
    channelDescription: 'Reminder to pray the perpetual novena every 28th',
    importance: Importance.high,
    priority: Priority.high,
    icon: 'ic_stat_cross',
  );

  static const _septemberChannel = AndroidNotificationDetails(
    'september_channel',
    'Novena and feast day',
    channelDescription: 'Daily novena reminders from September 19 to 28',
    importance: Importance.high,
    priority: Priority.high,
    icon: 'ic_stat_cross',
  );

  static const _darwinDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: false,
    presentSound: true,
  );

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } catch (e, s) {
      // Unknown identifiers fall back to UTC instead of skipping reminders.
      await LogService.instance.error(e, s);
    }

    const darwin = DarwinInitializationSettings(
      // Permission is requested explicitly (and only when needed) below.
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_cross'),
        iOS: darwin,
        macOS: darwin,
      ),
    );
    _initialized = true;
  }

  /// Asks for notification permission. Never redirects to system settings,
  /// so users who declined are not nagged on every launch.
  Future<bool> _requestPermission() async {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        return await android?.requestNotificationsPermission() ?? false;
      case TargetPlatform.iOS:
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        return await ios?.requestPermissions(alert: true, sound: true) ?? false;
      case TargetPlatform.macOS:
        final macos = _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >();
        return await macos?.requestPermissions(alert: true, sound: true) ??
            false;
      default:
        return false;
    }
  }

  /// Applies the user's reminder preference. Safe to call on every launch.
  ///
  /// Returns whether reminders are active afterwards.
  Future<bool> sync({required bool enabled}) async {
    if (kIsWeb) return false;
    try {
      await _ensureInitialized();

      if (!enabled) {
        await _plugin.cancelAll();
        return false;
      }
      if (!await _requestPermission()) return false;

      await _plugin.cancelAll();
      await _scheduleAll();
      return true;
    } catch (e, s) {
      await LogService.instance.error(e, s);
      return false;
    }
  }

  Future<void> _scheduleAll() async {
    await _schedule(
      id: _monthlyId,
      title: '✙ Today is Devotion Day',
      body: 'Pray the Perpetual Novena to St. Lorenzo Ruiz.',
      date: _next(day: 28, hour: 9),
      details: const NotificationDetails(
        android: _monthlyChannel,
        iOS: _darwinDetails,
        macOS: _darwinDetails,
      ),
      repeat: DateTimeComponents.dayOfMonthAndTime,
    );

    for (var day = 1; day <= 9; day++) {
      await _schedule(
        id: _novenaBaseId + 18 + day,
        title: '✙ Novena Day $day',
        body: 'Pray Day $day of the Novena to St. Lorenzo Ruiz.',
        date: _next(month: DateTime.september, day: 18 + day, hour: 8),
        details: const NotificationDetails(
          android: _septemberChannel,
          iOS: _darwinDetails,
          macOS: _darwinDetails,
        ),
        repeat: DateTimeComponents.dateAndTime,
      );
    }

    await _schedule(
      id: _feastId,
      title: 'Happy Feast of St. Lorenzo Ruiz!',
      body: 'Celebrate by singing or listening to his hymn in the app.',
      date: _next(month: DateTime.september, day: 28, hour: 6),
      details: const NotificationDetails(
        android: _septemberChannel,
        iOS: _darwinDetails,
        macOS: _darwinDetails,
      ),
      repeat: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime date,
    required NotificationDetails details,
    required DateTimeComponents repeat,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: date,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: repeat,
    );
  }

  /// Next occurrence of the given day (and month, if given) at [hour].
  tz.TZDateTime _next({int? month, required int day, required int hour}) {
    final now = tz.TZDateTime.now(tz.local);
    var year = now.year;
    var candidateMonth = month ?? now.month;

    tz.TZDateTime build() =>
        tz.TZDateTime(tz.local, year, candidateMonth, day, hour);

    var date = build();
    if (!date.isAfter(now)) {
      if (month == null) {
        candidateMonth++;
        if (candidateMonth > 12) {
          candidateMonth = 1;
          year++;
        }
      } else {
        year++;
      }
      date = build();
    }
    return date;
  }
}
