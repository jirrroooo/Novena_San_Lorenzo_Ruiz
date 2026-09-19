import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:novena_lorenzo/core/theme/app_theme.dart';

/// Soft colour pairs for [HeaderArt]. Each section gets its own muted hue so
/// the app is not red everywhere; equal lightness keeps them related.
enum ArtPalette {
  rose(Color(0xFFF2A0A0), Color(0xFFD35A60)),
  slate(Color(0xFF9DAEC6), Color(0xFF4F5F79)),
  sand(Color(0xFFD6BD93), Color(0xFF8A6C42)),
  sage(Color(0xFFA7BCA5), Color(0xFF55705A)),
  mauve(Color(0xFFB9A2C0), Color(0xFF6A5074)),
  stone(Color(0xFFB8AEA8), Color(0xFF625853));

  const ArtPalette(this.light, this.deep);

  final Color light;
  final Color deep;
}

/// Illustrated banner drawn in code: a warm gradient, radiating "glory" rays
/// and a gilded medallion holding a symbol for the section.
///
/// Replaces the previous AI-generated stained-glass images so all headers
/// share one visual language and adapt to dark mode.
class HeaderArt extends StatelessWidget {
  const HeaderArt({
    super.key,
    required this.icon,
    this.palette = ArtPalette.rose,
    this.medallionAlignment = const Alignment(0.62, -0.28),
    this.medallionSize = 96,
  });

  final IconData icon;
  final ArtPalette palette;
  final Alignment medallionAlignment;
  final double medallionSize;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final top = isDark
        ? Color.lerp(palette.light, Colors.black, 0.35)!
        : palette.light;
    final bottom = isDark
        ? Color.lerp(palette.deep, Colors.black, 0.4)!
        : palette.deep;

    return Semantics(
      excludeSemantics: true,
      child: CustomPaint(
        painter: _GloryPainter(
          top: top,
          bottom: bottom,
          focus: medallionAlignment,
        ),
        child: Align(
          alignment: medallionAlignment,
          child: _Medallion(icon: icon, size: medallionSize, fill: bottom),
        ),
      ),
    );
  }
}

class _Medallion extends StatelessWidget {
  const _Medallion({
    required this.icon,
    required this.size,
    required this.fill,
  });

  final IconData icon;
  final double size;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Color.lerp(fill, AppColors.gold, 0.25)!, fill],
        ),
        border: Border.all(color: AppColors.gold, width: size * 0.035),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.45),
            blurRadius: size * 0.35,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(size * 0.07),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.55),
            width: 1,
          ),
        ),
        child: Icon(icon, size: size * 0.44, color: const Color(0xFFFFF3D6)),
      ),
    );
  }
}

class _GloryPainter extends CustomPainter {
  _GloryPainter({required this.top, required this.bottom, required this.focus});

  final Color top;
  final Color bottom;
  final Alignment focus;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, bottom],
        ).createShader(rect),
    );

    final center = focus.alongSize(size);
    final radius = size.longestSide * 1.2;

    // Alternating wedges of light radiating from the medallion.
    const rays = 28;
    final wedge = Paint()..color = AppColors.gold.withValues(alpha: 0.07);
    for (var i = 0; i < rays; i += 2) {
      final a0 = (i / rays) * 2 * math.pi;
      final a1 = ((i + 1) / rays) * 2 * math.pi;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(
          center.dx + radius * math.cos(a0),
          center.dy + radius * math.sin(a0),
        )
        ..lineTo(
          center.dx + radius * math.cos(a1),
          center.dy + radius * math.sin(a1),
        )
        ..close();
      canvas.drawPath(path, wedge);
    }

    canvas.drawCircle(
      center,
      size.shortestSide * 0.9,
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                AppColors.gold.withValues(alpha: 0.35),
                AppColors.gold.withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCircle(center: center, radius: size.shortestSide * 0.9),
            ),
    );

    // Faint concentric halo rings.
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.gold.withValues(alpha: 0.18);
    for (final r in [0.34, 0.5, 0.68]) {
      canvas.drawCircle(center, size.shortestSide * r, ring);
    }
  }

  @override
  bool shouldRepaint(_GloryPainter old) =>
      old.top != top || old.bottom != bottom || old.focus != focus;
}
