import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';

/// Pinned page header used by every screen.
///
/// Expanded, it shows a large serif title, over a photo when [image] is set;
/// scrolled, it collapses into a plain toolbar on the page background.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.image,
    this.imageAlignment = Alignment.center,
    this.imageHeight = 300,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;

  /// Asset path of a photo shown behind the expanded title.
  final String? image;
  final Alignment imageAlignment;

  /// Expanded height (below the status bar) when there is a photo.
  final double imageHeight;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.sizeOf(context).width;
    final topPadding = MediaQuery.paddingOf(context).top;
    final scaler = MediaQuery.textScalerOf(context);
    final side = Space.side(width);

    final double expanded;
    if (image != null) {
      expanded = imageHeight;
    } else {
      // Size the header to its title so long titles are never clipped.
      final textWidth = width - side * 2;
      var height = _measure(title, textTheme.headlineSmall!, textWidth, scaler);
      if (subtitle != null) {
        height +=
            Space.xs +
            _measure(subtitle!, textTheme.bodyLarge!, textWidth, scaler);
      }
      expanded = kToolbarHeight + height + Space.l;
    }

    return SliverPersistentHeader(
      pinned: true,
      delegate: _HeaderDelegate(
        header: this,
        topPadding: topPadding,
        side: side,
        maxHeight: topPadding + expanded,
      ),
    );
  }

  static double _measure(
    String text,
    TextStyle style,
    double width,
    TextScaler scaler,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
      maxLines: 3,
    )..layout(maxWidth: width);
    final height = painter.height;
    painter.dispose();
    return height;
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({
    required this.header,
    required this.topPadding,
    required this.side,
    required this.maxHeight,
  });

  final PageHeader header;
  final double topPadding;
  final double side;
  final double maxHeight;

  @override
  double get minExtent => topPadding + kToolbarHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(_HeaderDelegate old) =>
      old.header != header ||
      old.topPadding != topPadding ||
      old.side != side ||
      old.maxHeight != maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool _) =>
      _HeaderBody(
        header: header,
        topPadding: topPadding,
        side: side,
        maxExtent: maxExtent,
        minExtent: minExtent,
        shrinkOffset: shrinkOffset,
      );
}

/// The header's content. A widget of its own so it rebuilds when the theme
/// changes (the delegate is only rebuilt on scroll).
class _HeaderBody extends StatelessWidget {
  const _HeaderBody({
    required this.header,
    required this.topPadding,
    required this.side,
    required this.maxExtent,
    required this.minExtent,
    required this.shrinkOffset,
  });

  final PageHeader header;
  final double topPadding;
  final double side;
  final double maxExtent;
  final double minExtent;
  final double shrinkOffset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final hasImage = header.image != null;

    final range = maxExtent - minExtent;
    // 1 when fully expanded, 0 when collapsed.
    final t = range <= 0 ? 0.0 : (1 - shrinkOffset / range).clamp(0.0, 1.0);
    // How visible the photo is; the toolbar turns white over it.
    final photo = hasImage ? ((t - 0.15) / 0.35).clamp(0.0, 1.0) : 0.0;
    final foreground = Color.lerp(scheme.onSurface, Colors.white, photo)!;
    final largeTitle = ((t - 0.4) / 0.6).clamp(0.0, 1.0);
    final smallTitle = (1 - t / 0.3).clamp(0.0, 1.0);
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: photo > 0.5
          ? StatusBarStyle.lightIcons
          : StatusBarStyle.onPage(theme.brightness),
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              Positioned(
                top: -shrinkOffset * 0.4,
                left: 0,
                right: 0,
                height: maxExtent,
                child: Opacity(
                  opacity: photo,
                  child: _Photo(
                    asset: header.image!,
                    alignment: header.imageAlignment,
                  ),
                ),
              ),
            Positioned(
              left: side,
              right: side,
              bottom: Space.l,
              child: Opacity(
                opacity: largeTitle,
                alwaysIncludeSemantics: true,
                child: _LargeTitle(
                  title: header.title,
                  subtitle: header.subtitle,
                  onPhoto: hasImage,
                ),
              ),
            ),
            Positioned(
              top: topPadding,
              left: 0,
              right: 0,
              height: kToolbarHeight,
              child: IconButtonTheme(
                data: IconButtonThemeData(
                  style: IconButton.styleFrom(foregroundColor: foreground),
                ),
                child: Row(
                  children: [
                    if (canPop)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.xs,
                        ),
                        child: BackButton(color: foreground),
                      )
                    else
                      SizedBox(width: side),
                    Expanded(
                      child: ExcludeSemantics(
                        child: Opacity(
                          opacity: smallTitle,
                          child: Text(
                            header.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              color: foreground,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...header.actions,
                    const SizedBox(width: Space.xs),
                  ],
                ),
              ),
            ),
            // Hairline once content scrolls under the collapsed header.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 1,
              child: AnimatedOpacity(
                opacity: shrinkOffset > range ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                child: ColoredBox(color: theme.dividerTheme.color!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.asset, required this.alignment});

  final String asset;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          asset,
          fit: BoxFit.cover,
          alignment: alignment,
          excludeFromSemantics: true,
        ),
        // Darkens the top for the status bar and the bottom for the title.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.3, 0.5, 1],
              colors: [
                Color(0x4D000000),
                Color(0x00000000),
                Color(0x00000000),
                Color(0xA6000000),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LargeTitle extends StatelessWidget {
  const _LargeTitle({
    required this.title,
    required this.subtitle,
    required this.onPhoto,
  });

  final String title;
  final String? subtitle;
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              color: onPhoto ? Colors.white : scheme.onSurface,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: Space.xs),
          Text(
            subtitle!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyLarge?.copyWith(
              color: onPhoto
                  ? Colors.white.withValues(alpha: 0.85)
                  : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
