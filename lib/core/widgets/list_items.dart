import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';

/// Rows on one rounded surface, separated by hairlines.
class ListGroup extends StatelessWidget {
  const ListGroup({
    super.key,
    required this.children,
    this.dividerIndent = Space.l,
  });

  final List<Widget> children;

  /// Where the hairlines start, usually aligned with the row text.
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(indent: dividerIndent),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// A row in a [ListGroup]: optional leading widget, title, subtitle and a
/// chevron when it can be tapped.
class ListRow extends StatelessWidget {
  const ListRow({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.highlightSubtitle = false,
    this.trailing,
    this.onTap,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;

  /// Shows the subtitle in the accent colour (used for "Today").
  final bool highlightSubtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Offset of the row text when [leading] is a 40px badge or 24px icon.
  static const double textIndentWithBadge = Space.l + 40 + Space.l;
  static const double textIndentWithIcon = Space.l + 24 + Space.l;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final trailing =
        this.trailing ??
        (onTap == null
            ? null
            : Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurfaceVariant,
              ));

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.l,
            vertical: Space.m,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                IconTheme.merge(
                  data: IconThemeData(color: scheme.onSurfaceVariant),
                  child: leading!,
                ),
                const SizedBox(width: Space.l),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: textTheme.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: Space.xs),
                      Text(
                        subtitle!,
                        style: textTheme.bodySmall?.copyWith(
                          color: highlightSubtitle
                              ? scheme.primary
                              : scheme.onSurfaceVariant,
                          fontWeight: highlightSubtitle
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: Space.s),
                trailing,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The day number of a novena day, filled in red when it is today.
class DayNumber extends StatelessWidget {
  const DayNumber(this.day, {super.key, this.today = false});

  final int day;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: today ? scheme.primary : null,
        border: today ? null : Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        '$day',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontFamily: AppFonts.serif,
          color: today ? scheme.onPrimary : scheme.onSurface,
        ),
      ),
    );
  }
}

/// Serif heading that opens a section of a screen ("Novenas", "His life").
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Space.xxl, bottom: Space.m),
      child: Semantics(
        header: true,
        child: Text(text, style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}

/// Small label above a [ListGroup], aligned with the row text.
class GroupLabel extends StatelessWidget {
  const GroupLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.l, Space.xl, Space.l, Space.s),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

/// A row of dots showing progress through the nine novena days. The filled
/// dots fill in one after another when the row first appears.
class ProgressDots extends StatelessWidget {
  const ProgressDots({
    super.key,
    required this.count,
    required this.filled,
    this.alignment = MainAxisAlignment.start,
  });

  final int count;
  final int filled;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Day $filled of $count',
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: filled.toDouble()),
        duration: Duration(milliseconds: 120 * filled + 200),
        curve: Curves.easeOut,
        builder: (context, value, _) => Row(
          mainAxisAlignment: alignment,
          children: [
            for (var i = 0; i < count; i++) ...[
              if (i > 0) const SizedBox(width: Space.s),
              _Dot(
                fill: (value - i).clamp(0.0, 1.0),
                current: i == filled - 1,
                color: scheme.primary,
                empty: scheme.outlineVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.fill,
    required this.current,
    required this.color,
    required this.empty,
  });

  final double fill;
  final bool current;
  final Color color;
  final Color empty;

  @override
  Widget build(BuildContext context) {
    final size = current ? 12.0 : 8.0;
    return SizedBox(
      width: 12,
      height: 12,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(empty, color, fill),
          ),
        ),
      ),
    );
  }
}
