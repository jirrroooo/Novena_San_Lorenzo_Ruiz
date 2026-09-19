import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class LinkService {
  /// Opens [url] outside the app, telling the user if that is not possible.
  static Future<void> open(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e, s) {
      await LogService.instance.error(e, s);
    }
    if (!opened) {
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('Could not open the link. Please try again later.'),
        ),
      );
    }
  }
}
