import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/settings/app_settings.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';
import 'package:novena_lorenzo/data/translation.dart';

/// Typography for devotional text, scaled by the user's reading text size.
class ReadingStyles {
  ReadingStyles._(this.scale, this.theme);

  factory ReadingStyles.of(BuildContext context) => ReadingStyles._(
    AppSettingsScope.of(context).textScale,
    Theme.of(context),
  );

  final double scale;
  final ThemeData theme;

  ColorScheme get _scheme => theme.colorScheme;

  TextStyle get body =>
      TextStyle(fontSize: 17 * scale, height: 1.6, color: _scheme.onSurface);

  TextStyle get emphasis => body.copyWith(fontStyle: FontStyle.italic);

  TextStyle get heading => TextStyle(
    fontSize: 21 * scale,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: _scheme.onSurface,
  );

  TextStyle get subheading => TextStyle(
    fontSize: 16 * scale,
    height: 1.4,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: _scheme.primary,
  );

  TextStyle get rubric => TextStyle(
    fontSize: 15 * scale,
    height: 1.5,
    fontStyle: FontStyle.italic,
    color: _scheme.onSurfaceVariant,
  );

  TextStyle get speaker => TextStyle(
    fontSize: 12.5 * scale,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.4,
    color: _scheme.onSurfaceVariant,
  );
}

/// Centres reading content with a comfortable line length on wide screens
/// and keeps it clear of the gesture/navigation bar (edge-to-edge).
class ReadingSliver extends StatelessWidget {
  const ReadingSliver({
    super.key,
    required this.children,
    this.top = 24,
    this.bottom = 32,
  });

  final List<Widget> children;
  final double top;
  final double bottom;

  static const double maxWidth = 680;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final side = math.max(
          20.0,
          (constraints.crossAxisExtent - maxWidth) / 2,
        );
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(side, top, side, bottom + bottomInset),
          sliver: SliverList.list(children: children),
        );
      },
    );
  }
}

/// Ornamental divider with a small cross, used between prayer sections.
class Ornament extends StatelessWidget {
  const Ornament({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Divider(color: color)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '✠',
              style: TextStyle(fontSize: 16, color: AppColors.gold, height: 1),
            ),
          ),
          Expanded(child: Divider(color: color)),
        ],
      ),
    );
  }
}

/// Label for a major part of a prayer (e.g. "Enot na Kabtang").
class PartLabel extends StatelessWidget {
  const PartLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 4),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.secondaryContainer,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: styles.speaker.copyWith(
                color: scheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section heading with an optional subtitle.
class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.title, {
    super.key,
    this.subtitle,
    this.ornament = true,
  });

  final String title;
  final String? subtitle;
  final bool ornament;

  @override
  Widget build(BuildContext context) {
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        children: [
          if (ornament) const Ornament(padding: EdgeInsets.only(bottom: 16)),
          Text(title, textAlign: TextAlign.center, style: styles.heading),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: styles.subheading,
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: ReadingStyles.of(context).rubric,
      ),
    );
  }
}

/// Who reads the following lines, e.g. "Lider" or "Gabos".
class Speaker extends StatelessWidget {
  const Speaker(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 2),
      child: Text(
        label.toUpperCase(),
        style: ReadingStyles.of(context).speaker,
      ),
    );
  }
}

/// A response said by everyone; visually set apart with an accent bar.
class ResponseBlock extends StatelessWidget {
  const ResponseBlock(this.text, {super.key, this.label});

  final String text;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final styles = ReadingStyles.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: scheme.primary.withValues(alpha: 0.6),
              width: 3,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null)
                Text(label!.toUpperCase(), style: styles.speaker),
              if (label != null) const SizedBox(height: 4),
              Text(
                text,
                style: styles.emphasis.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
    final scheme = Theme.of(context).colorScheme;
    final styles = ReadingStyles.of(context);
    final isBicol = translation == Translation.bicol;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            isBicol ? '✠  Pag-antanda nin Krus  ✠' : '✠  Sign of the Cross  ✠',
            textAlign: TextAlign.center,
            style: styles.subheading.copyWith(color: scheme.primary),
          ),
          const SizedBox(height: 8),
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
