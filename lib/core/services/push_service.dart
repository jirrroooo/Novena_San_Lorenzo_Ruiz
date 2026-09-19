import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';
import 'package:novena_lorenzo/core/services/reminder_service.dart';

/// Runs in a background isolate for data messages. Notification messages are
/// displayed by the OS while the app is in the background, so there is
/// nothing else to do here (the app has no deep links or inbox).
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {}

/// Firebase Cloud Messaging setup.
///
/// Every install subscribes to the [broadcastTopic] topic, so announcements
/// can be sent from the Firebase console ("Messaging" → target: Topic
/// `all`) without a server or stored tokens.
///
/// Firebase is optional at build time: until `google-services.json` (Android)
/// and `GoogleService-Info.plist` (iOS) are added, initialization fails
/// quietly and the rest of the app works as before.
class PushService {
  PushService._();

  static final PushService instance = PushService._();

  static const broadcastTopic = 'all';

  bool _started = false;

  Future<void> start() async {
    if (_started || kIsWeb) return;
    _started = true;

    try {
      await Firebase.initializeApp();
    } catch (e) {
      await LogService.instance.info(
        'Push disabled: Firebase is not configured ($e)',
      );
      return;
    }

    try {
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
      final messaging = FirebaseMessaging.instance;

      // iOS shows notifications while the app is open; Android does not, so
      // foreground messages are displayed through the local notifications
      // plugin instead.
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        sound: true,
      );
      FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        if (notification == null ||
            defaultTargetPlatform != TargetPlatform.android) {
          return;
        }
        ReminderService.instance.showAnnouncement(
          title: notification.title,
          body: notification.body,
        );
      });

      if (kDebugMode) {
        // Handy for "Send test message" in the Firebase console.
        debugPrint('FCM token: ${await messaging.getToken()}');
      }

      // Permission is requested together with the prayer reminders; this
      // only subscribes the device (no extra prompt).
      await messaging.subscribeToTopic(broadcastTopic);
    } catch (e, s) {
      // e.g. iOS before an APNs token is available; retried next launch.
      await LogService.instance.error(e, s);
    }
  }
}
