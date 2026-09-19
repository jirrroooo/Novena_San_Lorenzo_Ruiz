import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/devotion_calendar.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/data/translation.dart';

/// The nine novena days as tappable cards; today's day is highlighted during
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < titles.length; i++)
          EntryCard(
            leading: DayBadge(day: i + 1, highlighted: today == i + 1),
            tag: today == i + 1 ? 'Today · ${dayNames[i]}' : dayNames[i],
            highlightTag: today == i + 1,
            title: titles[i],
            onTap: () => onOpen(i + 1),
          ),
      ],
    );
  }
}

/// Footer on a novena day: go to the next day, or back to the list.
class NextDayButton extends StatelessWidget {
  const NextDayButton({
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
    final isLast = day >= totalDays;
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: isLast
          ? OutlinedButton.icon(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Novena completed'),
            )
          : FilledButton.icon(
              onPressed: onNext,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text('Continue to Day ${day + 1}'),
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
