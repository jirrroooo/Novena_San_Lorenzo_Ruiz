import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/widgets/hymn_mini_player.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/core/widgets/novena_widgets.dart';
import 'package:novena_lorenzo/core/widgets/page_header.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/prayers/prayer_repository.dart';

const Map<String, IconData> _icons = {
  'Financial': Icons.savings_outlined,
  'Family': Icons.family_restroom_outlined,
  'OFW': Icons.flight_takeoff_outlined,
  'Job Seekers': Icons.work_outline_rounded,
  'Students': Icons.school_outlined,
  'Doubts and Fears': Icons.shield_moon_outlined,
  'Faith': Icons.local_fire_department_outlined,
  'Morning Prayer': Icons.wb_twilight_outlined,
  'Night Prayer': Icons.bedtime_outlined,
  'Healing': Icons.healing_outlined,
};

const Set<String> _daily = {'Morning Prayer', 'Night Prayer'};

/// Prayers tab: daily prayers and intentions to bring to St. Lorenzo Ruiz.
class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const PageHeader(
          title: 'Prayers',
          subtitle: 'Through the intercession of St. Lorenzo Ruiz',
        ),
        ContentSliver<List<Prayer>>(
          load: const PrayerRepository().load,
          builder: (context, prayers) => ReadingSliver(
            top: 0,
            children: [
              const GroupLabel('Daily'),
              _PrayerGroup(
                prayers: [
                  for (final p in prayers)
                    if (_daily.contains(p.shortTitle)) p,
                ],
              ),
              const GroupLabel('For your intentions'),
              _PrayerGroup(
                prayers: [
                  for (final p in prayers)
                    if (!_daily.contains(p.shortTitle)) p,
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrayerGroup extends StatelessWidget {
  const _PrayerGroup({required this.prayers});

  final List<Prayer> prayers;

  @override
  Widget build(BuildContext context) {
    return ListGroup(
      dividerIndent: ListRow.textIndentWithIcon,
      children: [
        for (final prayer in prayers)
          ListRow(
            leading: Icon(_icons[prayer.shortTitle] ?? Icons.favorite_outline),
            title: prayer.englishTitle,
            subtitle: prayer.hasBicol ? 'English · Bicol' : 'English',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PrayerPage(prayer: prayer),
              ),
            ),
          ),
      ],
    );
  }
}

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key, required this.prayer});

  final Prayer prayer;

  @override
  State<PrayerPage> createState() => _PrayerPageState();
}

class _PrayerPageState extends State<PrayerPage> {
  Translation _translation = Translation.english;

  @override
  Widget build(BuildContext context) {
    final prayer = widget.prayer;
    final isBicol = _translation == Translation.bicol && prayer.hasBicol;
    final title = isBicol ? prayer.bicolTitle! : prayer.englishTitle;
    final text = isBicol ? prayer.bicolText! : prayer.englishText;
    final translation = isBicol ? Translation.bicol : Translation.english;

    return PageScaffold(
      slivers: [
        PageHeader(
          title: title,
          subtitle: 'Prayer to St. Lorenzo Ruiz',
          actions: const [ReadingSettingsButton()],
        ),
        ReadingSliver(
          top: 8,
          children: [
            if (prayer.hasBicol)
              LanguageToggle(
                value: _translation,
                onChanged: (t) => setState(() => _translation = t),
              ),
            SignOfTheCross(translation: translation),
            Paragraphs(text),
            SignOfTheCross(translation: translation),
          ],
        ),
      ],
    );
  }
}
