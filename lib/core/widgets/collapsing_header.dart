import 'package:flutter/material.dart';

/// Pinned, collapsing app bar used by every screen.
///
/// Expanded, it shows [background] with a large title and optional subtitle;
/// collapsed, it shrinks to a normal toolbar with a single-line title.
class CollapsingHeader extends StatelessWidget {
  const CollapsingHeader({
    super.key,
    required this.title,
    required this.background,
    this.subtitle,
    this.actions = const [],
    this.expandedHeight = 240,
  });

  final String title;
  final String? subtitle;
  final Widget background;
  final List<Widget> actions;
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      actions: [...actions, const SizedBox(width: 4)],
      flexibleSpace: _HeaderSpace(
        title: title,
        subtitle: subtitle,
        background: background,
        leadingWidth: canPop ? 56 : 20,
        actionsWidth: actions.length * 48.0 + 8,
      ),
    );
  }
}

class _HeaderSpace extends StatelessWidget {
  const _HeaderSpace({
    required this.title,
    required this.subtitle,
    required this.background,
    required this.leadingWidth,
    required this.actionsWidth,
  });

  final String title;
  final String? subtitle;
  final Widget background;
  final double leadingWidth;
  final double actionsWidth;

  @override
  Widget build(BuildContext context) {
    final settings = context
        .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final range = settings == null
        ? 1.0
        : (settings.maxExtent - settings.minExtent).clamp(1.0, double.infinity);
    // 1 when fully expanded, 0 when collapsed.
    final t = settings == null
        ? 1.0
        : ((settings.currentExtent - settings.minExtent) / range).clamp(
            0.0,
            1.0,
          );
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            fit: StackFit.expand,
            children: [
              background,
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.3, 0.55, 1],
                    colors: [
                      Color(0x66000000),
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xB3000000),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Large title, fades out while collapsing.
        Positioned(
          left: 20,
          right: 20,
          bottom: 18,
          child: IgnorePointer(
            child: Opacity(
              opacity: ((t - 0.35) / 0.65).clamp(0.0, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      shadows: const [
                        Shadow(blurRadius: 12, color: Color(0x80000000)),
                      ],
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        shadows: const [
                          Shadow(blurRadius: 8, color: Color(0x80000000)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Toolbar title, fades in once collapsed.
        Positioned(
          left: leadingWidth,
          right: actionsWidth,
          bottom: 0,
          height: kToolbarHeight,
          child: IgnorePointer(
            child: Opacity(
              opacity: (1 - t / 0.35).clamp(0.0, 1.0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A full-bleed photo/artwork header background.
class HeaderImage extends StatelessWidget {
  const HeaderImage(this.asset, {super.key, this.alignment = Alignment.center});

  final String asset;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      alignment: alignment,
      excludeFromSemantics: true,
    );
  }
}
