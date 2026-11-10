import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novena_lorenzo/core/services/log_service.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class LinkService {
  /// Opens [url] outside the app, telling the user if that is not possible.
  static Future<void> open(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (await _launch(Uri.parse(url))) return;
    _show(messenger, 'Could not open the link. Check your connection.');
  }

  /// Starts an email to [address] in the user's mail app.
  ///
  /// Phones without a mail app set up (and the iOS simulator) cannot open
  /// `mailto:` links, so the address is copied instead, ready to paste into
  /// any mail service.
  static Future<void> email(
    BuildContext context,
    String address, {
    String? subject,
  }) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final uri = Uri(
      scheme: 'mailto',
      path: address,
      query: subject == null ? null : 'subject=${Uri.encodeComponent(subject)}',
    );
    if (await _launch(uri)) return;
    await Clipboard.setData(ClipboardData(text: address));
    _show(messenger, 'No email app found. $address was copied.');
  }

  static Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, s) {
      await LogService.instance.error(e, s);
      return false;
    }
  }

  static void _show(ScaffoldMessengerState? messenger, String message) {
    messenger
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
