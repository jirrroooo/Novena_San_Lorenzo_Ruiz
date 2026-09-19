import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/widgets/collapsing_header.dart';
import 'package:novena_lorenzo/core/widgets/credits.dart';
import 'package:novena_lorenzo/core/widgets/header_art.dart';
import 'package:novena_lorenzo/core/widgets/novena_widgets.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/novena_english/novena_english_repository.dart';
import 'package:novena_lorenzo/features/scripture/scripture_card.dart';

const _art = HeaderArt(
  icon: Icons.menu_book_rounded,
  palette: ArtPalette.slate,
);

class NovenaEnglishHome extends StatelessWidget {
  const NovenaEnglishHome({super.key});

  static const routeName = '/english-novena';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CollapsingHeader(
            title: 'English Novena',
            subtitle: 'Nine days with St. Lorenzo Ruiz',
            background: _art,
          ),
          const ScriptureSliver(translation: Translation.english),
          ContentSliver<EnglishNovena>(
            load: const NovenaEnglishRepository().load,
            builder: (context, novena) => ReadingSliver(
              top: 20,
              children: [
                NovenaDayList(
                  titles: [for (final d in novena.days) d.title],
                  dayNames: [for (final d in novena.days) d.dayName],
                  onOpen: (day) => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => NovenaEnglishDayPage(day: day),
                    ),
                  ),
                ),
                const ApprovalCredits(translation: Translation.english),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NovenaEnglishDayPage extends StatelessWidget {
  const NovenaEnglishDayPage({super.key, required this.day});

  /// 1-based novena day.
  final int day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CollapsingHeader(
            title: 'Day $day',
            subtitle: 'English Novena',
            background: _art,
            actions: const [ReadingSettingsButton()],
          ),
          ContentSliver<EnglishNovena>(
            load: const NovenaEnglishRepository().load,
            builder: (context, novena) {
              final d = novena.days[day - 1];
              return ReadingSliver(
                children: [
                  SectionTitle(
                    'NOVENA TO SAINT LORENZO RUIZ',
                    subtitle: d.dayName,
                    ornament: false,
                  ),
                  const SignOfTheCross(translation: Translation.english),
                  const SectionTitle('Act of Contrition'),
                  Paragraphs(novena.actOfContrition),
                  const SectionTitle('Opening Prayer'),
                  Paragraphs(novena.openingPrayer),
                  PartLabel('${d.dayName} Reflection'),
                  SectionTitle(d.title, ornament: false),
                  Paragraphs(d.reflection),
                  Rubric('(${novena.reflectionInstruction})'),
                  const SectionTitle('Act of Supplication'),
                  for (final supplication in novena.supplications) ...[
                    Paragraph(supplication),
                    ResponseBlock(novena.supplicationResponse, label: 'All'),
                  ],
                  const SectionTitle(
                    "The Lord's Prayer",
                    subtitle: 'In honor of the Holy Passion of Jesus Christ',
                  ),
                  Paragraph(novena.ourFather),
                  const SignOfTheCross(translation: Translation.english),
                  NextDayButton(
                    day: day,
                    totalDays: novena.days.length,
                    onNext: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => NovenaEnglishDayPage(day: day + 1),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
