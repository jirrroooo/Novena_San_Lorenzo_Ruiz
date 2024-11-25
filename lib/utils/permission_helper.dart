import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:novena_lorenzo/main.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestNotificationPermission() async {
  const Permission permission = Permission.notification;

  var status = await permission.status;

  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    if (await permission.request().isGranted) {
      return true;
    } else {
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    bool opened = await openAppSettings();
    if (opened) {
      return await permission.status.isGranted;
    }
    return false;
  }

  return false;
}

Future<bool> requestExactAlarmPermission() async {
  const Permission permission = Permission.scheduleExactAlarm;

  var status = await permission.status;

  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    if (await permission.request().isGranted) {
      return true;
    } else {
      return false;
    }
  } else if (status.isPermanentlyDenied) {
    bool opened = await openAppSettings();
    if (opened) {
      return await permission.status.isGranted;
    }
    return false;
  }

  return false;
}

void requestPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}
