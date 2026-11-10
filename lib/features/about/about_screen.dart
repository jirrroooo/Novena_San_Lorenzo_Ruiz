import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/services/link_service.dart';
import 'package:novena_lorenzo/core/services/reminder_service.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/credits.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/core/widgets/page_header.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';

const _privacyPolicyUrl = 'https://johnrommeloctavo.com/novena/privacy';
const _termsOfServiceUrl = 'https://johnrommeloctavo.com/novena/terms';
const _contactEmail = 'jiro.octavo@gmail.com';

/// "More" tab: settings, credits and information about the app.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final external = Icon(
      Icons.open_in_new_rounded,
      size: 20,
      color: scheme.onSurfaceVariant,
    );

    return CustomScrollView(
      slivers: [
        const PageHeader(title: 'Settings & About'),
        ReadingSliver(
          top: 0,
          children: [
            const GroupLabel('Reading'),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(Space.l),
                child: ReadingSettingsPanel(inSheet: false),
              ),
            ),
            const GroupLabel('Reminders'),
            const Card(child: _RemindersTile()),
            const GroupLabel('About the app'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(Space.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: const AssetImage(
                            'assets/images/jiro.webp',
                          ),
                          backgroundColor: scheme.surfaceContainerHighest,
                        ),
                        const SizedBox(width: Space.l),
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
                                style: textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.l),
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
                      last: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Space.m),
            ListGroup(
              dividerIndent: ListRow.textIndentWithIcon,
              children: [
                ListRow(
                  leading: const Icon(Icons.mail_outline_rounded),
                  title: 'Feedback & corrections',
                  subtitle: _contactEmail,
                  trailing: external,
                  onTap: () => LinkService.email(
                    context,
                    _contactEmail,
                    subject: 'St. Lorenzo Ruiz Novena',
                  ),
                ),
                ListRow(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: 'Privacy policy',
                  trailing: external,
                  onTap: () => LinkService.open(context, _privacyPolicyUrl),
                ),
                ListRow(
                  leading: const Icon(Icons.gavel_rounded),
                  title: 'Terms of Service',
                  trailing: external,
                  onTap: () => LinkService.open(context, _termsOfServiceUrl),
                ),
                ListRow(
                  leading: const Icon(Icons.description_outlined),
                  title: 'Open-source licenses',
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'St. Lorenzo Ruiz Novena',
                  ),
                ),
              ],
            ),
            const ApprovalCredits(
              translation: Translation.bicol,
              heading: 'Bicol novena text',
            ),
            const ApprovalCredits(
              translation: Translation.english,
              heading: 'English novena text',
            ),
          ],
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text, {this.last = false});

  final String text;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : Space.m),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge
            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
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
      contentPadding: const EdgeInsets.symmetric(
        horizontal: Space.l,
        vertical: Space.xs,
      ),
      secondary: const Icon(Icons.notifications_none_rounded),
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
