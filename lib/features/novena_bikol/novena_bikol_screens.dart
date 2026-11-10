import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/widgets/credits.dart';
import 'package:novena_lorenzo/core/widgets/hymn_mini_player.dart';
import 'package:novena_lorenzo/core/widgets/novena_widgets.dart';
import 'package:novena_lorenzo/core/widgets/page_header.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/novena_bikol/novena_bikol_repository.dart';

class NovenaBikolHome extends StatelessWidget {
  const NovenaBikolHome({super.key});

  static const routeName = '/bicol-novena';

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      slivers: [
        const PageHeader(
          title: 'Bicol Novena',
          subtitle: 'Rinibong Buhay para sa Dios',
        ),
        ContentSliver<BikolNovena>(
          load: const NovenaBikolRepository().load,
          builder: (context, novena) => ReadingSliver(
            top: 8,
            children: [
              NovenaDayList(
                titles: [for (final d in novena.days) d.title],
                dayNames: [for (final d in novena.days) d.dayName],
                onOpen: (day) => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => NovenaBikolDayPage(day: day),
                  ),
                ),
              ),
              const ApprovalCredits(translation: Translation.bicol),
            ],
          ),
        ),
      ],
    );
  }
}

class NovenaBikolDayPage extends StatelessWidget {
  const NovenaBikolDayPage({super.key, required this.day});

  /// 1-based novena day.
  final int day;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      slivers: [
        PageHeader(
          title: 'Day $day',
          subtitle: 'Bicol Novena',
          actions: const [ReadingSettingsButton()],
        ),
        ContentSliver<BikolNovena>(
          load: const NovenaBikolRepository().load,
          builder: (context, novena) {
            final d = novena.days[day - 1];
            return ReadingSliver(
              top: 0,
              children: [
                ..._opening(novena),
                ..._partOne(novena),
                ..._partTwo(novena, d),
                ..._partThree(novena, d),
                const SignOfTheCross(translation: Translation.bicol),
                NovenaDayFooter(
                  day: day,
                  totalDays: novena.days.length,
                  onNext: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => NovenaBikolDayPage(day: day + 1),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> _opening(BikolNovena n) => [
    SectionTitle(n.title, subtitle: n.subtitle),
    Paragraph(n.quote, italic: true, center: true),
    const SignOfTheCross(translation: Translation.bicol),
    const SectionTitle('Pamibi sa Aroaldaw'),
    Paragraphs(n.dailyPrayer),
  ];

  List<Widget> _partOne(BikolNovena n) => [
    const PartLabel('Enot na Kabtang'),
    SectionTitle(n.praiseTitle),
    const Speaker('Antifona'),
    VerseLines(n.antiphon),
    const Speaker('Lider'),
    Paragraphs(n.openingPrayer),
    Rubric('(${n.canticleReference})'),
    for (final lines in n.canticle) ...[
      const Speaker('Lider'),
      VerseLines(lines, italic: false),
      ResponseBlock(n.canticleResponse, label: 'Gabos'),
    ],
  ];

  List<Widget> _partTwo(BikolNovena n, BikolNovenaDay d) => [
    const PartLabel('Ikaduwang Kabtang'),
    const SectionTitle('Nobena ki San Lorenzo Martir'),
    const Speaker('Lider'),
    Paragraph(n.partTwoIntro),
    SectionTitle(d.title, eyebrow: d.dayName),
    Paragraphs(d.reflection),
    const SectionTitle('Tataramon nin Dios'),
    Paragraph(d.wordOfGod, italic: true),
    const Rubric('(Maontok nin kadikit na panahon sa paghorop-horop)'),
  ];

  List<Widget> _partThree(BikolNovena n, BikolNovenaDay d) => [
    const PartLabel('Ika-tolong Kabtang'),
    SectionTitle(n.partThreeTitle),
    const Speaker('Lider'),
    Paragraph(n.partThreeIntro),
    SectionTitle('Pamibi sa ${d.dayName}'),
    for (final petition in d.petitions) ...[
      const Speaker('Lider'),
      Paragraph(petition),
      ResponseBlock(n.petitionResponse, label: 'Gabos'),
    ],
    const SectionTitle('Huring Pamibi'),
    Paragraph(n.closingPrayer),
  ];
}
