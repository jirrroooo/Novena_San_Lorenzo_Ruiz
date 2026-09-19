import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';

/// App bar action that opens [showReadingSettings].
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
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final index = AppSettings.textScales.indexOf(settings.textScale);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (inSheet) ...[
          Text('Reading settings', style: textTheme.titleLarge),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Text('Text size', style: textTheme.titleSmall),
            const Spacer(),
            Text(
              _labels[index],
              style: textTheme.labelLarge?.copyWith(color: scheme.primary),
            ),
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Blessed are they who are persecuted for the sake of righteousness, '
            'for theirs is the kingdom of heaven.',
            style: ReadingStyles.of(context).emphasis,
          ),
        ),
        const SizedBox(height: 24),
        Text('Appearance', style: textTheme.titleSmall),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: ThemeMode.system,
              icon: Icon(Icons.brightness_auto_rounded),
              label: Text('System'),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              icon: Icon(Icons.light_mode_rounded),
              label: Text('Light'),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              icon: Icon(Icons.dark_mode_rounded),
              label: Text('Dark'),
            ),
          ],
          selected: {settings.themeMode},
          onSelectionChanged: (s) => settings.setThemeMode(s.first),
        ),
      ],
    );

    if (!inSheet) return content;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: content,
    );
  }
}
