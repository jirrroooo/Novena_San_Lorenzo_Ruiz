import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum LogLevel { info, warn, error }

class LogService {
  static const int maxLogSize = 10 * 1024; // 10KB

  // Future<void> printLogFilePath() async {
  //   final directories = await getExternalStorageDirectories();

  //   if (directories != null && directories.isNotEmpty) {
  //     print('Log file path +++++ ====>>>>>>> ${directories[0].path}/app_log');
  //   }
  // }

  Future<File> _getLogFile() async {
    final directory = await getExternalStorageDirectories();
    return File('${directory?[0].path}/app_log');
  }

  Future<void> log(String message, {LogLevel level = LogLevel.info}) async {
    final file = await _getLogFile();

    if (await file.exists()) {
      final fileSize = await file.length();
      if (fileSize >= maxLogSize) {
        await file.writeAsString('');
      }
    }

    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] [${level.name.toUpperCase()}]: $message\n';

    await file.writeAsString(logEntry, mode: FileMode.append);
  }

  Future<void> logInfo(String message) async =>
      log(message, level: LogLevel.info);
  Future<void> logWarn(String message) async =>
      log(message, level: LogLevel.warn);
  Future<void> logError(String message) async =>
      log(message, level: LogLevel.error);
}
