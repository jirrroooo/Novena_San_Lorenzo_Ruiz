import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';

/// Thrown when bundled devotional content cannot be read.
class ContentLoadException implements Exception {
  const ContentLoadException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Loads and caches the bundled JSON content under `lib/data/`.
abstract final class ContentLoader {
  static final Map<String, Future<dynamic>> _cache = {};

  static Future<dynamic> load(String fileName) {
    return _cache.putIfAbsent(fileName, () async {
      try {
        final raw = await rootBundle.loadString('lib/data/$fileName');
        return jsonDecode(raw);
      } catch (e, s) {
        _cache.remove(fileName);
        await LogService.instance.error(e, s);
        throw ContentLoadException(
          'Could not open $fileName. Please try again.',
        );
      }
    });
  }

  /// Runs [parse] on the decoded content, turning malformed data into a
  /// [ContentLoadException] with a user-facing [what] description.
  static Future<T> parse<T>(
    String fileName,
    String what,
    T Function(dynamic json) parse,
  ) async {
    final json = await load(fileName);
    try {
      return parse(json);
    } catch (e, s) {
      await LogService.instance.error(e, s);
      throw ContentLoadException('The $what could not be loaded.');
    }
  }
}

List<String> stringList(dynamic value) =>
    (value as List<dynamic>).map((e) => e as String).toList();
