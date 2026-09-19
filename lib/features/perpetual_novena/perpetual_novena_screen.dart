import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/content/content_cubit.dart';
import 'package:novena_lorenzo/core/widgets/collapsing_header.dart';
import 'package:novena_lorenzo/core/widgets/credits.dart';
import 'package:novena_lorenzo/core/widgets/header_art.dart';
import 'package:novena_lorenzo/core/widgets/novena_widgets.dart';
import 'package:novena_lorenzo/core/widgets/reading.dart';
import 'package:novena_lorenzo/core/widgets/reading_settings_sheet.dart';
import 'package:novena_lorenzo/data/translation.dart';
import 'package:novena_lorenzo/features/perpetual_novena/perpetual_novena_repository.dart';

class PerpetualNovenaScreen extends StatefulWidget {
  const PerpetualNovenaScreen({super.key});

  static const routeName = '/perpetual-novena';

  @override
  State<PerpetualNovenaScreen> createState() => _PerpetualNovenaScreenState();
}

class _PerpetualNovenaScreenState extends State<PerpetualNovenaScreen> {
  Translation _translation = Translation.english;

  @override
  Widget build(BuildContext context) {
    final isBicol = _translation == Translation.bicol;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CollapsingHeader(
            title: isBicol ? 'Danay na Nobena' : 'Perpetual Novena',
            subtitle: 'Prayed every 28th of the month',
            background: const HeaderArt(
              icon: Icons.event_repeat_rounded,
              palette: ArtPalette.sand,
            ),
            actions: const [ReadingSettingsButton()],
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(
              child: LanguageToggle(
                value: _translation,
                onChanged: (t) => setState(() => _translation = t),
              ),
            ),
          ),
          ContentSliver<PerpetualNovena>(
            // A new key reloads the content when the language changes.
            key: ValueKey(_translation),
            load: () => const PerpetualNovenaRepository().load(_translation),
            builder: (context, n) => ReadingSliver(
              top: 8,
              children: [
                SectionTitle(n.title, ornament: false),
                SignOfTheCross(translation: _translation),
                Paragraphs(n.prayer),
                SectionTitle(isBicol ? 'Ama Niamo' : "The Lord's Prayer"),
                Paragraph(n.ourFather),
                SectionTitle(isBicol ? 'Ave Maria' : 'Hail Mary'),
                Paragraph(n.hailMary),
                SectionTitle(isBicol ? 'Kamurawayan sa Dios' : 'Glory Be'),
                Paragraph(n.gloryBe),
                SectionTitle(isBicol ? 'Huring Pamibi' : 'Closing Prayer'),
                Paragraphs(n.lastPrayer),
                SignOfTheCross(translation: _translation),
                ApprovalCredits(translation: _translation, showHeading: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
