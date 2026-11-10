import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/devotion_calendar.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/data/translation.dart';

/// The nine novena days as one grouped list; today's day is marked during
/// the novena (September 19–27).
class NovenaDayList extends StatelessWidget {
  const NovenaDayList({
    super.key,
    required this.titles,
    required this.dayNames,
    required this.onOpen,
  });

  final List<String> titles;
  final List<String> dayNames;
  final ValueChanged<int> onOpen; // 1-based day

  @override
  Widget build(BuildContext context) {
    final today = DevotionCalendar.novenaDay(DateTime.now());
    return ListGroup(
      dividerIndent: ListRow.textIndentWithBadge,
      children: [
        for (var i = 0; i < titles.length; i++)
          ListRow(
            leading: DayNumber(i + 1, today: today == i + 1),
            title: titles[i],
            subtitle: today == i + 1 ? 'Today · ${dayNames[i]}' : dayNames[i],
            highlightSubtitle: today == i + 1,
            onTap: () => onOpen(i + 1),
          ),
      ],
    );
  }
}

/// Closes a novena day: progress through the nine days and the way on.
class NovenaDayFooter extends StatelessWidget {
  const NovenaDayFooter({
    super.key,
    required this.day,
    required this.totalDays,
    required this.onNext,
  });

  final int day;
  final int totalDays;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final isLast = day >= totalDays;

    return Padding(
      padding: const EdgeInsets.only(top: Space.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Ornament(),
          const SizedBox(height: Space.xl),
          ProgressDots(
            count: totalDays,
            filled: day,
            alignment: MainAxisAlignment.center,
          ),
          const SizedBox(height: Space.m),
          Text(
            isLast ? 'The novena is complete' : 'Day $day of $totalDays',
            textAlign: TextAlign.center,
            style: textTheme.titleLarge,
          ),
          if (isLast) ...[
            const SizedBox(height: Space.s),
            Text(
              'May St. Lorenzo Ruiz pray for you. '
              'His feast is on September 28.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Space.xl),
          if (isLast)
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Back to Home'),
            )
          else
            FilledButton.icon(
              onPressed: onNext,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text('Continue to Day ${day + 1}'),
            ),
        ],
      ),
    );
  }
}

/// Switches a prayer between English and Bicol.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Translation value;
  final ValueChanged<Translation> onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton<Translation>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: Translation.english, label: Text('English')),
          ButtonSegment(value: Translation.bicol, label: Text('Bicol')),
        ],
        selected: {value},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}
