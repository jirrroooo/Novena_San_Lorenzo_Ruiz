import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/widgets/collapsing_header.dart';
import 'package:novena_lorenzo/core/widgets/header_art.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/core/widgets/novena_widgets.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/prayers/prayer_repository.dart';
import 'package:novena_lorenzo/features/scripture/scripture_card.dart';

const _art = HeaderArt(
  icon: Icons.volunteer_activism_rounded,
  palette: ArtPalette.sage,
);

const Map<String, IconData> _icons = {
  'Financial': Icons.savings_rounded,
  'Family': Icons.family_restroom_rounded,
  'OFW': Icons.flight_takeoff_rounded,
  'Job Seekers': Icons.work_rounded,
  'Students': Icons.school_rounded,
  'Doubts and Fears': Icons.shield_moon_rounded,
  'Faith': Icons.local_fire_department_rounded,
  'Morning Prayer': Icons.wb_twilight_rounded,
  'Night Prayer': Icons.bedtime_rounded,
  'Healing': Icons.healing_rounded,
};

/// Prayers tab: intentions to bring to St. Lorenzo Ruiz.
class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CollapsingHeader(
          title: 'Prayers',
          subtitle: 'Intentions entrusted to St. Lorenzo Ruiz',
          background: _art,
        ),
        const ScriptureSliver(),
        ContentSliver<List<Prayer>>(
          load: const PrayerRepository().load,
          builder: (context, prayers) => ReadingSliver(
            top: 20,
            children: [
              for (final prayer in prayers)
                EntryCard(
                  leading: IconBadge(
                    _icons[prayer.shortTitle] ?? Icons.favorite_rounded,
                  ),
                  title: prayer.englishTitle,
                  subtitle: prayer.hasBicol ? prayer.bicolTitle : null,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PrayerPage(
                        prayer: prayer,
                        icon:
                            _icons[prayer.shortTitle] ?? Icons.favorite_rounded,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class PrayerPage extends StatefulWidget {
  const PrayerPage({super.key, required this.prayer, required this.icon});

  final Prayer prayer;
  final IconData icon;

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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CollapsingHeader(
            title: title,
            subtitle: 'Prayer to St. Lorenzo Ruiz',
            background: HeaderArt(icon: widget.icon, palette: ArtPalette.sage),
            actions: const [ReadingSettingsButton()],
          ),
          ReadingSliver(
            top: 20,
            children: [
              if (prayer.hasBicol)
                LanguageToggle(
                  value: _translation,
                  onChanged: (t) => setState(() => _translation = t),
                ),
              SignOfTheCross(
                translation: isBicol ? Translation.bicol : Translation.english,
              ),
              Paragraphs(text),
              SignOfTheCross(
                translation: isBicol ? Translation.bicol : Translation.english,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
