import 'package:flutter/material.dart';
import 'package:novena_lorenzo/app/main_navigation.dart';
import 'package:novena_lorenzo/core/content/devotion_calendar.dart';
import 'package:novena_lorenzo/core/services/hymn_audio.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/core/widgets/page_header.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/features/novena_bikol/novena_bikol_screens.dart';
import 'package:novena_lorenzo/features/novena_english/novena_english_screens.dart';
import 'package:novena_lorenzo/features/perpetual_novena/perpetual_novena_screen.dart';
import 'package:novena_lorenzo/features/scripture/scripture_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = MainNavigation.of(context);

    return CustomScrollView(
      slivers: [
        const PageHeader(
          title: 'San Lorenzo Ruiz',
          subtitle: 'Feast day · September 28',
          image: 'assets/images/lorenzo5.webp',
          imageAlignment: Alignment(0, -0.6),
          imageHeight: 320,
        ),
        ReadingSliver(
          children: [
            TodayCard(
              onPlayHymn: () {
                nav.select(AppTab.hymn);
                HymnAudio.instance.play();
              },
            ),
            const SizedBox(height: Space.xxl),
            const VerseOfTheDay(),
            const SectionHeading('Novenas'),
            ListGroup(
              dividerIndent: ListRow.textIndentWithIcon,
              children: [
                ListRow(
                  leading: const Icon(Icons.church_outlined),
                  title: 'Bicol Novena',
                  subtitle: 'Nobena sa Bikol · nine days',
                  onTap: () =>
                      Navigator.pushNamed(context, NovenaBikolHome.routeName),
                ),
                ListRow(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: 'English Novena',
                  subtitle: 'Nine days with St. Lorenzo Ruiz',
                  onTap: () =>
                      Navigator.pushNamed(context, NovenaEnglishHome.routeName),
                ),
                ListRow(
                  leading: const Icon(Icons.event_repeat_outlined),
                  title: 'Perpetual Novena',
                  subtitle: 'Prayed on the 28th of every month',
                  onTap: () => Navigator.pushNamed(
                    context,
                    PerpetualNovenaScreen.routeName,
                  ),
                ),
              ],
            ),
            const SectionHeading('His life'),
            _BiographyTeaser(onTap: () => nav.select(AppTab.life)),
          ],
        ),
      ],
    );
  }
}

/// What to pray today: a novena day, the feast or the monthly devotion, and
/// otherwise how long until the next of them.
class TodayCard extends StatelessWidget {
  const TodayCard({super.key, required this.onPlayHymn, this.date});

  final VoidCallback onPlayHymn;

  /// The day to describe; defaults to today.
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final now = date ?? DateTime.now();
    final novenaDay = DevotionCalendar.novenaDay(now);
    final daysToNovena = DevotionCalendar.daysBetween(
      now,
      DevotionCalendar.nextNovenaStart(now),
    );

    final _TodayContent content;
    if (novenaDay != null) {
      content = _TodayContent(
        label: 'Today · Novena to St. Lorenzo Ruiz',
        value: 'Day $novenaDay of ${DevotionCalendar.novenaDays}',
        progress: novenaDay,
        body: 'Pray today’s novena in English or Bicol.',
        actions: [
          FilledButton.tonal(
            onPressed: () =>
                _push(context, NovenaEnglishDayPage(day: novenaDay)),
            child: const Text('English'),
          ),
          FilledButton.tonal(
            onPressed: () => _push(context, NovenaBikolDayPage(day: novenaDay)),
            child: const Text('Bicol'),
          ),
        ],
      );
    } else if (DevotionCalendar.isFeastDay(now)) {
      content = _TodayContent(
        label: 'Today',
        value: 'Feast of St. Lorenzo Ruiz',
        body:
            'The first Filipino saint, martyred in Nagasaki in 1637. '
            'Celebrate with his hymn.',
        actions: [
          FilledButton.tonal(
            onPressed: onPlayHymn,
            child: const Text('Play the hymn'),
          ),
        ],
      );
    } else if (DevotionCalendar.isDevotionDay(now)) {
      content = _TodayContent(
        label: 'Today',
        value: 'Day of devotion',
        body: 'The Perpetual Novena is prayed on the 28th of every month.',
        actions: [_perpetualButton(context, 'Pray the Perpetual Novena')],
      );
    } else if (daysToNovena <= 30) {
      content = _TodayContent(
        label: 'Novena to St. Lorenzo Ruiz',
        value: 'Begins ${DevotionCalendar.relative(daysToNovena)}',
        body:
            'Nine days of prayer, September 19–27, '
            'leading to his feast on the 28th.',
      );
    } else {
      final next = DevotionCalendar.nextDevotionDay(now);
      content = _TodayContent(
        label: 'Next day of devotion',
        value: DevotionCalendar.formatDay(next),
        meta: DevotionCalendar.relative(
          DevotionCalendar.daysBetween(now, next),
        ),
        body: 'The Perpetual Novena is prayed on the 28th of every month.',
        actions: [_perpetualButton(context, 'Pray it now')],
      );
    }

    return _TodayCardView(content: content);
  }

  static Widget _perpetualButton(BuildContext context, String label) =>
      FilledButton.tonal(
        onPressed: () =>
            Navigator.pushNamed(context, PerpetualNovenaScreen.routeName),
        child: Text(label),
      );

  static void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}

class _TodayContent {
  const _TodayContent({
    required this.label,
    required this.value,
    required this.body,
    this.meta,
    this.progress,
    this.actions = const [],
  });

  final String label;
  final String value;
  final String? meta;
  final String body;

  /// Novena day to show as progress dots.
  final int? progress;
  final List<Widget> actions;
}

class _TodayCardView extends StatelessWidget {
  const _TodayCardView({required this.content});

  final _TodayContent content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final secondary = textTheme.bodyLarge?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Container(
      padding: const EdgeInsets.all(Space.xl),
      decoration: BoxDecoration(
        color: AppTheme.groupColor(theme),
        borderRadius: BorderRadius.circular(AppRadius.group),
        boxShadow: AppShadows.raised(theme.brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content.label,
            style: textTheme.titleSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Space.s),
          Text(content.value, style: textTheme.headlineSmall),
          if (content.meta != null) ...[
            const SizedBox(height: Space.xs),
            Text(content.meta!, style: secondary),
          ],
          if (content.progress != null) ...[
            const SizedBox(height: Space.l),
            ProgressDots(
              count: DevotionCalendar.novenaDays,
              filled: content.progress!,
            ),
          ],
          const SizedBox(height: Space.m),
          Text(content.body, style: secondary),
          if (content.actions.isNotEmpty) ...[
            const SizedBox(height: Space.xl),
            Row(
              children: [
                for (var i = 0; i < content.actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: Space.m),
                  Expanded(child: content.actions[i]),
                ],
              ],
            ),
          ],
        ],
      ),
    );
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
          children: [
            SizedBox(
              width: 96,
              height: 128,
              child: Image.asset(
                'assets/images/lorenzo3.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.5),
                excludeFromSemantics: true,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Space.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The first Filipino saint',
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: Space.xs),
                    Text(
                      'Husband, father and calligrapher from Binondo, '
                      'martyred in Nagasaki in 1637.',
                      style: textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: Space.l),
              child: Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
