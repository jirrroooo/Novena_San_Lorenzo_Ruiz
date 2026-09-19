import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

enum LogLevel { info, warn, error }

/// Small rotating file logger stored in the app's private support directory.
///
/// Logging must never break the caller, so every failure here is swallowed.
class LogService {
  LogService._();

  static final LogService instance = LogService._();

  static const int _maxLogSize = 10 * 1024; // 10 KB

  Future<File> _logFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/app_log.txt');
  }

  Future<void> log(String message, {LogLevel level = LogLevel.info}) async {
    final entry =
        '[${DateTime.now().toIso8601String()}] [${level.name.toUpperCase()}]: $message\n';
    debugPrint(entry.trimRight());

    if (kIsWeb) return;
    try {
      final file = await _logFile();
      if (await file.exists() && await file.length() >= _maxLogSize) {
        await file.writeAsString('');
      }
      await file.writeAsString(entry, mode: FileMode.append);
    } catch (_) {
      // Ignore: a failed log write should never surface to the user.
    }
  }

  Future<void> info(String message) => log(message);
  Future<void> warn(String message) => log(message, level: LogLevel.warn);
  Future<void> error(Object error, [StackTrace? stackTrace]) => log(
    stackTrace == null ? '$error' : '$error\n$stackTrace',
    level: LogLevel.error,
  );
}
