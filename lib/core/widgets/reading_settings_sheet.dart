import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';

/// Toolbar action that opens [showReadingSettings].
class ReadingSettingsButton extends StatelessWidget {
  const ReadingSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Text size & theme',
      icon: const Icon(Icons.text_fields_rounded),
      onPressed: () => showReadingSettings(context),
    );
  }
}

Future<void> showReadingSettings(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const ReadingSettingsPanel(),
  );
}

/// Text size and appearance controls. Changes apply instantly everywhere and
/// are remembered between launches.
class ReadingSettingsPanel extends StatelessWidget {
  const ReadingSettingsPanel({super.key, this.inSheet = true});

  final bool inSheet;

  static const _labels = [
    'Small',
    'Normal',
    'Large',
    'Larger',
    'Huge',
    'Largest',
  ];

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final index = AppSettings.textScales.indexOf(settings.textScale);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (inSheet) ...[
          Text('Reading', style: textTheme.titleLarge),
          const SizedBox(height: Space.l),
        ],
        Row(
          children: [
            Text('Text size', style: textTheme.bodyLarge),
            const Spacer(),
            Text(_labels[index], style: textTheme.titleMedium),
          ],
        ),
        Row(
          children: [
            IconButton(
              tooltip: 'Smaller text',
              onPressed: index > 0
                  ? () =>
                        settings.setTextScale(AppSettings.textScales[index - 1])
                  : null,
              icon: const Icon(Icons.text_decrease_rounded),
            ),
            Expanded(
              child: Slider(
                value: index.toDouble(),
                max: (AppSettings.textScales.length - 1).toDouble(),
                divisions: AppSettings.textScales.length - 1,
                label: _labels[index],
                semanticFormatterCallback: (v) => _labels[v.round()],
                onChanged: (v) =>
                    settings.setTextScale(AppSettings.textScales[v.round()]),
              ),
            ),
            IconButton(
              tooltip: 'Larger text',
              onPressed: index < AppSettings.textScales.length - 1
                  ? () =>
                        settings.setTextScale(AppSettings.textScales[index + 1])
                  : null,
              icon: const Icon(Icons.text_increase_rounded),
            ),
          ],
        ),
        const SizedBox(height: Space.s),
        // Live sample of the prayer text at the chosen size.
        Container(
          padding: const EdgeInsets.all(Space.l),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: Text(
            'Blessed are they who are persecuted for the sake of righteousness, '
            'for theirs is the kingdom of heaven.',
            style: ReadingStyles.of(context).body,
          ),
        ),
        const SizedBox(height: Space.xl),
        Text('Appearance', style: textTheme.bodyLarge),
        const SizedBox(height: Space.s),
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          expandedInsets: EdgeInsets.zero,
          segments: const [
            ButtonSegment(value: ThemeMode.system, label: Text('System')),
            ButtonSegment(value: ThemeMode.light, label: Text('Light')),
            ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (s) => settings.setThemeMode(s.first),
        ),
      ],
    );

    if (!inSheet) return content;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.xl),
      child: content,
    );
  }
}
