import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/data/translation.dart';

/// Typography for devotional text, scaled by the user's reading text size.
///
/// Set like a missal: serif text, red italic rubrics, and red small capitals
/// for who speaks. Three sizes (22, 17, 15) and two weights.
class ReadingStyles {
  ReadingStyles._(this.scale, this.theme);

  factory ReadingStyles.of(BuildContext context) => ReadingStyles._(
    AppSettingsScope.of(context).textScale,
    Theme.of(context),
  );

  final double scale;
  final ThemeData theme;

  ColorScheme get _scheme => theme.colorScheme;

  TextStyle get body => TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 17 * scale,
    height: 1.6,
    color: _scheme.onSurface,
  );

  TextStyle get emphasis => body.copyWith(fontStyle: FontStyle.italic);

  TextStyle get heading => TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 22 * scale,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: _scheme.onSurface,
  );

  /// Instructions for the one praying (not read aloud): red italic.
  TextStyle get rubric => TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 15 * scale,
    height: 1.5,
    fontStyle: FontStyle.italic,
    color: _scheme.primary,
  );

  /// Secondary line under a heading.
  TextStyle get note => rubric.copyWith(color: _scheme.onSurfaceVariant);

  /// Who speaks ("Lider", "Gabos") and part names: red small capitals.
  TextStyle get label => TextStyle(
    fontFamily: AppFonts.serif,
    fontSize: 15 * scale,
    height: 1.4,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: _scheme.primary,
    fontFeatures: const [FontFeature.enable('smcp')],
  );
}

/// Centres reading content with a comfortable line length on wide screens
/// and keeps it clear of the gesture/navigation bar (edge-to-edge).
class ReadingSliver extends StatelessWidget {
  const ReadingSliver({
    super.key,
    required this.children,
    this.top = Space.xl,
    this.bottom = Space.xxl,
  });

  final List<Widget> children;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final side = Space.side(constraints.crossAxisExtent);
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(side, top, side, bottom + bottomInset),
          sliver: SliverList.list(children: children),
        );
      },
    );
  }
}

/// Thin gold rule with a cross, marking the major parts of a prayer.
class Ornament extends StatelessWidget {
  const Ornament({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: Space.s),
  });

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.gold.withValues(alpha: 0.5);
    return ExcludeSemantics(
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            const Spacer(),
            Expanded(child: Divider(color: color)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Space.m),
              child: Text(
                '✠',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gold,
                  height: 1,
                ),
              ),
            ),
            Expanded(child: Divider(color: color)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

/// Opens a major part of a prayer (e.g. "Enot na Kabtang").
class PartLabel extends StatelessWidget {
  const PartLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Space.xxxl, bottom: Space.xs),
      child: Column(
        children: [
          const Ornament(padding: EdgeInsets.zero),
          const SizedBox(height: Space.m),
          Semantics(
            header: true,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: ReadingStyles.of(context).label,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section heading, with an optional red label above and a note below.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.eyebrow, this.subtitle});

  final String title;
  final String? eyebrow;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: Space.xxl, bottom: Space.m),
      child: Column(
        children: [
          if (eyebrow != null) ...[
            Text(eyebrow!, textAlign: TextAlign.center, style: styles.label),
            const SizedBox(height: Space.xs),
          ],
          Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: styles.heading,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: Space.xs),
            Text(subtitle!, textAlign: TextAlign.center, style: styles.note),
          ],
        ],
      ),
    );
  }
}

/// A paragraph of prayer or reflection text.
class Paragraph extends StatelessWidget {
  const Paragraph(
    this.text, {
    super.key,
    this.italic = false,
    this.center = false,
  });

  final String text;
  final bool italic;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.s),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: italic ? styles.emphasis : styles.body,
      ),
    );
  }
}

/// Several paragraphs from content data.
class Paragraphs extends StatelessWidget {
  const Paragraphs(
    this.texts, {
    super.key,
    this.italic = false,
    this.center = false,
  });

  final List<String> texts;
  final bool italic;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final text in texts)
          Paragraph(text, italic: italic, center: center),
      ],
    );
  }
}

/// Instruction for the one praying (not read aloud).
class Rubric extends StatelessWidget {
  const Rubric(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.m),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: ReadingStyles.of(context).rubric,
      ),
    );
  }
}

/// Who reads the following lines, e.g. "Lider" or "Koro".
class Speaker extends StatelessWidget {
  const Speaker(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Space.l, bottom: Space.xs),
      child: Text(label, style: ReadingStyles.of(context).label),
    );
  }
}

/// A response said by everyone ("Gabos", "All"): a red label like the
/// leader's, then the response in semibold so the people's part stands out.
class ResponseBlock extends StatelessWidget {
  const ResponseBlock(this.text, {super.key, this.label});

  final String text;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: Space.l, bottom: Space.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(label!, style: styles.label),
            const SizedBox(height: Space.xs),
          ],
          Text(text, style: styles.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// Short verse lines (antiphons, hymn stanzas) centred on the page.
class VerseLines extends StatelessWidget {
  const VerseLines(this.lines, {super.key, this.italic = true});

  final List<String> lines;
  final bool italic;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.s),
      child: Text(
        lines.join('\n'),
        textAlign: TextAlign.center,
        style: (italic ? styles.emphasis : styles.body).copyWith(height: 1.7),
      ),
    );
  }
}

/// The Sign of the Cross that opens and closes each prayer.
class SignOfTheCross extends StatelessWidget {
  const SignOfTheCross({super.key, required this.translation});

  final Translation translation;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    final isBicol = translation == Translation.bicol;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.l),
      child: Column(
        children: [
          Text(
            isBicol ? 'Pag-antanda nin Krus' : 'Sign of the Cross',
            textAlign: TextAlign.center,
            style: styles.label,
          ),
          const SizedBox(height: Space.xs),
          Text(
            isBicol
                ? 'Sa ngaran kan Ama, asin kan Aki, pati an Espiritu Santo. Amen.'
                : 'In the name of the Father, and of the Son, and of the Holy Spirit. Amen.',
            textAlign: TextAlign.center,
            style: styles.emphasis,
          ),
        ],
      ),
    );
  }
}
