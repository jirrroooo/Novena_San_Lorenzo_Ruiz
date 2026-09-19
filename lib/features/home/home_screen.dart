import 'package:flutter/material.dart';
import 'package:novena_lorenzo/app/main_navigation.dart';
import 'package:novena_lorenzo/core/content/devotion_calendar.dart';
import 'package:novena_lorenzo/core/widgets/collapsing_header.dart';
import 'package:novena_lorenzo/core/widgets/header_art.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/novena_bikol/novena_bikol_screens.dart';
import 'package:novena_lorenzo/features/novena_english/novena_english_screens.dart';
import 'package:novena_lorenzo/features/perpetual_novena/perpetual_novena_screen.dart';
import 'package:novena_lorenzo/features/scripture/scripture_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nav = MainNavigation.of(context);

    Widget sectionLabel(String text) => Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        text,
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
    );

    return CustomScrollView(
      slivers: [
        const CollapsingHeader(
          title: 'San Lorenzo Ruiz',
          subtitle: 'Novena · Prayers · Hymn',
          expandedHeight: 300,
          background: HeaderImage(
            'assets/images/lorenzo5.webp',
            alignment: Alignment(0, -0.6),
          ),
        ),
        ReadingSliver(
          top: 16,
          bottom: 0,
          children: [_TodayCard(onOpenHymn: () => nav.select(AppTab.hymn))],
        ),
        const ScriptureSliver(translation: Translation.english),
        ReadingSliver(
          top: 0,
          children: [
            sectionLabel('Pray'),
            _FeatureGrid(
              items: [
                _Feature(
                  title: 'Bicol Novena',
                  subtitle: 'Nobena sa Bikol',
                  icon: Icons.church_rounded,
                  palette: ArtPalette.rose,
                  onTap: () =>
                      Navigator.pushNamed(context, NovenaBikolHome.routeName),
                ),
                _Feature(
                  title: 'English Novena',
                  subtitle: 'Nine days of prayer',
                  icon: Icons.menu_book_rounded,
                  palette: ArtPalette.slate,
                  onTap: () =>
                      Navigator.pushNamed(context, NovenaEnglishHome.routeName),
                ),
                _Feature(
                  title: 'Perpetual Novena',
                  subtitle: 'Every 28th',
                  icon: Icons.event_repeat_rounded,
                  palette: ArtPalette.sand,
                  onTap: () => Navigator.pushNamed(
                    context,
                    PerpetualNovenaScreen.routeName,
                  ),
                ),
                _Feature(
                  title: 'Prayers',
                  subtitle: 'For your intentions',
                  icon: Icons.volunteer_activism_rounded,
                  palette: ArtPalette.sage,
                  onTap: () => nav.select(AppTab.prayers),
                ),
              ],
            ),
            sectionLabel('His life'),
            _BiographyTeaser(onTap: () => nav.select(AppTab.life)),
          ],
        ),
      ],
    );
  }
}

class _Feature {
  const _Feature({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.palette,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ArtPalette palette;
  final VoidCallback onTap;
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.items});

  final List<_Feature> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 4 : 2;
        const spacing = 12.0;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _FeatureCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.item});

  final _Feature item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: item.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 96,
              child: HeaderArt(
                icon: item.icon,
                palette: item.palette,
                medallionAlignment: Alignment.center,
                medallionSize: 60,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Highlights what to pray today: a novena day, the feast or devotion day.
class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.onOpenHymn});

  final VoidCallback onOpenHymn;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final novenaDay = DevotionCalendar.novenaDay(now);

    final (String title, String body, List<Widget> actions) content;
    if (novenaDay != null) {
      content = (
        'Novena Day $novenaDay',
        'The novena to St. Lorenzo Ruiz is being prayed today.',
        [
          _action(
            context,
            'English',
            () => _push(context, NovenaEnglishDayPage(day: novenaDay)),
          ),
          _action(
            context,
            'Bicol',
            () => _push(context, NovenaBikolDayPage(day: novenaDay)),
          ),
        ],
      );
    } else if (DevotionCalendar.isFeastDay(now)) {
      content = (
        'Happy Feast Day!',
        'Today is the feast of St. Lorenzo Ruiz. Celebrate with his hymn.',
        [_action(context, 'Play the hymn', onOpenHymn)],
      );
    } else if (DevotionCalendar.isDevotionDay(now)) {
      content = (
        'Today is Devotion Day',
        'Pray the Perpetual Novena, as is done every 28th of the month.',
        [
          _action(
            context,
            'Pray now',
            () => Navigator.pushNamed(context, PerpetualNovenaScreen.routeName),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }

    final (title, body, actions) = content;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.primaryContainer.withValues(alpha: 0.55),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.18)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: scheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(color: scheme.onPrimaryContainer, height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }

  static Widget _action(
    BuildContext context,
    String label,
    VoidCallback onTap,
  ) {
    return FilledButton(
      style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
      onPressed: onTap,
      child: Text(label),
    );
  }

  static void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _BiographyTeaser extends StatelessWidget {
  const _BiographyTeaser({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              height: 180,
              child: Image.asset(
                'assets/images/lorenzo3.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.5),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The first Filipino saint',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'A husband, father and calligrapher from Binondo who died a '
                      'martyr in Nagasaki in 1637, refusing to renounce his faith.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Read his life →',
                      style: textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
