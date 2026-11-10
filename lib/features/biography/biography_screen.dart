import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/services/link_service.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/core/widgets/list_items.dart';
import 'package:novena_lorenzo/core/widgets/page_header.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/features/biography/biography_repository.dart';

const _videoUrl = 'https://www.youtube.com/watch?v=vtO7Ubf9ygg';

/// Life tab: key facts and the story of St. Lorenzo Ruiz as a timeline.
class BiographyScreen extends StatelessWidget {
  const BiographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const PageHeader(
          title: 'St. Lorenzo Ruiz',
          subtitle: 'First Filipino saint and martyr',
          image: 'assets/images/lorenzo1.webp',
          imageAlignment: Alignment(0, -0.4),
          imageHeight: 280,
          actions: [ReadingSettingsButton()],
        ),
        ContentSliver<Biography>(
          load: const BiographyRepository().load,
          builder: (context, bio) => ReadingSliver(
            children: [
              _FactsGroup(facts: bio.facts),
              const SizedBox(height: Space.m),
              ListGroup(
                children: [
                  ListRow(
                    leading: const _VideoThumbnail(),
                    title: 'Watch his story',
                    subtitle: 'On YouTube · needs internet',
                    trailing: Icon(
                      Icons.open_in_new_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onTap: () => LinkService.open(context, _videoUrl),
                  ),
                ],
              ),
              const SectionHeading('His story'),
              for (var i = 0; i < bio.sections.length; i++)
                _TimelineEntry(
                  section: bio.sections[i],
                  isLast: i == bio.sections.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FactsGroup extends StatelessWidget {
  const _FactsGroup({required this.facts});

  final List<BiographyFact> facts;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return ListGroup(
      children: [
        for (final fact in facts)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.l,
              vertical: Space.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fact.label,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Space.xs),
                Text(fact.value, style: styles.body.copyWith(height: 1.4)),
              ],
            ),
          ),
      ],
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  const _VideoThumbnail();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 64,
        height: 48,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/lorenzo5.webp',
              fit: BoxFit.cover,
              excludeFromSemantics: true,
            ),
            const ColoredBox(color: Color(0x4D000000)),
            const Icon(Icons.play_arrow_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// One chapter of his life on a vertical timeline.
class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.section, required this.isLast});

  final BiographySection section;
  final bool isLast;

  static const double _dot = 12;
  static const double _line = 2;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final styles = ReadingStyles.of(context);
    final heading = styles.heading;
    // Centres the dot on the first line of the heading.
    final dotTop = (heading.fontSize! * heading.height! - _dot) / 2;

    return Stack(
      children: [
        if (!isLast)
          Positioned(
            left: (_dot - _line) / 2,
            top: dotTop + _dot,
            bottom: 0,
            width: _line,
            child: ColoredBox(color: scheme.outlineVariant),
          ),
        Positioned(
          left: 0,
          top: dotTop,
          child: Container(
            width: _dot,
            height: _dot,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scheme.primary, width: 2),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: _dot + Space.l,
            bottom: isLast ? 0 : Space.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(section.title, style: heading),
              ),
              const SizedBox(height: Space.xs),
              for (final point in section.points) _Point(point),
            ],
          ),
        ),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: styles.body.fontSize! * 0.65,
              right: Space.m,
            ),
            child: Icon(
              Icons.circle,
              size: 5,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(child: Text(text, style: styles.body)),
        ],
      ),
    );
  }
}
