import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';

/// Numbered medallion used for the novena days.
class DayBadge extends StatelessWidget {
  const DayBadge({super.key, required this.day, this.highlighted = false});

  final int day;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: highlighted ? scheme.primary : scheme.surfaceContainerHighest,
        border: Border.all(
          color: highlighted ? AppColors.gold : scheme.outlineVariant,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DAY',
            style: TextStyle(
              fontSize: 8.5,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: highlighted
                  ? scheme.onPrimary.withValues(alpha: 0.85)
                  : scheme.onSurfaceVariant,
            ),
          ),
          Text(
            '$day',
            style: TextStyle(
              fontSize: 19,
              height: 1.1,
              fontWeight: FontWeight.w800,
              color: highlighted ? scheme.onPrimary : scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded icon tile used as the leading element of list entries.
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: scheme.onSecondaryContainer),
    );
  }
}

/// A tappable card row with a leading badge, title, subtitle and chevron.
class EntryCard extends StatelessWidget {
  const EntryCard({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.tag,
    this.highlightTag = false,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final String? tag;
  final bool highlightTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tag != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            tag!.toUpperCase(),
                            style: textTheme.labelSmall?.copyWith(
                              color: highlightTag
                                  ? scheme.primary
                                  : scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
