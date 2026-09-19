import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/services/link_service.dart';
import 'package:novena_lorenzo/core/services/reminder_service.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/widgets/collapsing_header.dart';
import 'package:novena_lorenzo/core/widgets/credits.dart';
import 'package:novena_lorenzo/core/widgets/header_art.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';

const _privacyPolicyUrl =
    'https://www.termsfeed.com/live/7263e95b-e3b4-47f2-aa5e-92a8050331a3';
const _contactEmail = 'jiro.octavo@gmail.com';

/// "More" tab: settings, credits and information about the app.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Text(
        text,
        style: textTheme.titleSmall?.copyWith(color: scheme.primary),
      ),
    );

    return CustomScrollView(
      slivers: [
        const CollapsingHeader(
          title: 'Settings & About',
          subtitle: 'St. Lorenzo Ruiz Novena',
          background: HeaderArt(
            icon: Icons.tune_rounded,
            palette: ArtPalette.stone,
          ),
        ),
        ReadingSliver(
          top: 0,
          children: [
            heading('Reading'),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ReadingSettingsPanel(inSheet: false),
              ),
            ),
            heading('Reminders'),
            const Card(child: _RemindersTile()),
            heading('About the app'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: const AssetImage(
                            'assets/images/jiro.webp',
                          ),
                          backgroundColor: scheme.primaryContainer,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Rommel B. Octavo',
                                style: textTheme.titleMedium,
                              ),
                              Text(
                                'App Developer',
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _Body(
                      'Welcome to the St. Lorenzo Ruiz Novena App, created to deepen '
                      'devotion to the first Filipino saint, St. Lorenzo Ruiz.',
                    ),
                    const _Body(
                      'The novena included in this app is not an original work of the '
                      'developer. Proper attribution to its authors is provided within the app.',
                    ),
                    const _Body(
                      'The developer is dedicated to creating Catholic-themed applications '
                      'designed to strengthen faith and foster devotion through technology. '
                      'This humble work is dedicated to the Almighty God.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.mail_outline_rounded),
                    title: const Text('Feedback & corrections'),
                    subtitle: const Text(_contactEmail),
                    onTap: () => LinkService.open(
                      context,
                      'mailto:$_contactEmail?subject=St.%20Lorenzo%20Ruiz%20Novena',
                    ),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy policy'),
                    trailing: const Icon(Icons.open_in_new_rounded, size: 20),
                    onTap: () => LinkService.open(context, _privacyPolicyUrl),
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Open-source licenses'),
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: 'St. Lorenzo Ruiz Novena',
                    ),
                  ),
                ],
              ),
            ),
            heading('Novena texts'),
            const ApprovalCredits(translation: Translation.bicol),
            const ApprovalCredits(translation: Translation.english),
          ],
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

class _RemindersTile extends StatefulWidget {
  const _RemindersTile();

  @override
  State<_RemindersTile> createState() => _RemindersTileState();
}

class _RemindersTileState extends State<_RemindersTile> {
  bool _busy = false;

  Future<void> _toggle(AppSettings settings, bool enabled) async {
    setState(() => _busy = true);
    final active = await ReminderService.instance.sync(enabled: enabled);
    await settings.setRemindersEnabled(active);
    if (!mounted) return;
    setState(() => _busy = false);
    if (enabled && !active) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notifications are turned off for this app. '
            'Allow them in your device settings to get reminders.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    return SwitchListTile(
      secondary: const Icon(Icons.notifications_active_outlined),
      title: const Text('Prayer reminders'),
      subtitle: const Text(
        'Novena days (Sept 19–27), the feast day (Sept 28) '
        'and the 28th of every month',
      ),
      value: settings.remindersEnabled,
      onChanged: _busy ? null : (v) => _toggle(settings, v),
    );
  }
}
