import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/services/link_service.dart';
import 'package:novena_lorenzo/core/widgets/collapsing_header.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/features/biography/biography_repository.dart';
import 'package:novena_lorenzo/features/scripture/scripture_card.dart';

const _videoUrl = 'https://www.youtube.com/watch?v=vtO7Ubf9ygg';

/// Life tab: key facts and the story of St. Lorenzo Ruiz.
class BiographyScreen extends StatelessWidget {
  const BiographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CollapsingHeader(
          title: 'St. Lorenzo Ruiz',
          subtitle: 'First Filipino saint and martyr',
          background: HeaderImage(
            'assets/images/lorenzo1.webp',
            alignment: Alignment(0, -0.4),
          ),
          actions: [ReadingSettingsButton()],
        ),
        const ScriptureSliver(),
        ContentSliver<Biography>(
          load: const BiographyRepository().load,
          builder: (context, bio) => ReadingSliver(
            top: 20,
            children: [
              _FactsCard(facts: bio.facts),
              const SizedBox(height: 12),
              const _VideoCard(),
              for (final section in bio.sections) ...[
                SectionTitle(section.title),
                for (final point in section.points) _Point(point),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FactsCard extends StatelessWidget {
  const _FactsCard({required this.facts});

  final List<BiographyFact> facts;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < facts.length; i++) ...[
              if (i > 0) const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(facts[i].label.toUpperCase(), style: styles.speaker),
                    const SizedBox(height: 2),
                    Text(
                      facts[i].value,
                      style: styles.body.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onTap: () => LinkService.open(context, _videoUrl),
        child: Row(
          children: [
            SizedBox(
              width: 112,
              height: 84,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/lorenzo5.webp', fit: BoxFit.cover),
                  const ColoredBox(color: Color(0x55000000)),
                  const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Watch his story', style: textTheme.titleMedium),
                  Text(
                    'Opens in YouTube · requires internet',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.open_in_new_rounded),
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: styles.body.fontSize! * 0.55,
              right: 12,
            ),
            child: Icon(
              Icons.circle,
              size: 7,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(child: Text(text, style: styles.body)),
        ],
      ),
    );
  }
}
