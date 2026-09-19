import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novena_lorenzo/app/app.dart';
import 'package:novena_lorenzo/core/services/reminder_service.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Draw behind the status and navigation bars (Android 15+ enforces this);
  // screens handle the insets themselves.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final settings = await AppSettings.load();
  runApp(NovenaApp(settings: settings));

  // Scheduled after the first frame so the native splash is not held up by
  // the notification permission prompt.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final active = await ReminderService.instance.sync(
      enabled: settings.remindersEnabled,
    );
    if (!active && settings.remindersEnabled) {
      // Permission was declined: reflect it in Settings instead of asking
      // again on every launch. Users can re-enable reminders there.
      await settings.setRemindersEnabled(false);
    }
  });
}
