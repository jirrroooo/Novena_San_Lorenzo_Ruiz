import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Colours shared by the app.
///
/// The look follows a printed missal: warm paper, dark ink, and liturgical
/// red used only where a missal would use it (today's marker, the main
/// action, rubrics and responses). Gold appears only in thin ornaments.
/// The native splash keeps its own colours (see flutter_native_splash.yaml).
abstract final class AppColors {
  /// Liturgical red for light mode: 6:1 on white, so it is legible as text.
  static const Color red = Color(0xFFB0383F);

  /// Muted gold for ✠ ornaments.
  static const Color gold = Color(0xFFB8964A);

  /// Warm grey that seeds the neutral (paper) surfaces.
  static const Color warmGrey = Color(0xFF8A817C);
}

abstract final class AppFonts {
  /// Serif for prayer text and titles. Interface text uses the platform font.
  static const String serif = 'Literata';
}

/// 4/8-point spacing scale.
abstract final class Space {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Widest a column of text gets before it is centred.
  static const double maxContentWidth = 680;

  /// Horizontal page margin: 20 on phones, wider to centre content on tablets.
  static double side(double width) =>
      math.max(20, (width - maxContentWidth) / 2);
}

abstract final class AppRadius {
  static const double group = 16;
  static const double small = 12;
}

/// The single soft shadow, for raised elements (Today card, hymn player).
/// Tinted warm brown so it sits naturally on the paper background.
abstract final class AppShadows {
  static List<BoxShadow> raised(Brightness brightness) =>
      brightness == Brightness.light
      ? const [
          BoxShadow(
            color: Color(0x143B2A20),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x0A3B2A20),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ];
}

/// Status bar icon styles. Only icon brightness is set: bar colours are left
/// to the edge-to-edge window, so no deprecated colour APIs are hit.
abstract final class StatusBarStyle {
  static const SystemUiOverlayStyle lightIcons = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );
  static const SystemUiOverlayStyle darkIcons = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  /// Icons that read on the plain page background of [brightness].
  static SystemUiOverlayStyle onPage(Brightness brightness) =>
      brightness == Brightness.light ? darkIcons : lightIcons;
}

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  /// Background of grouped rows and cards: white on light paper, a step
  /// lighter than the page in dark mode.
  static Color groupColor(ThemeData theme) =>
      theme.brightness == Brightness.light
      ? theme.colorScheme.surfaceContainerLowest
      : theme.colorScheme.surfaceContainer;

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    // Accents come from the red seed; surfaces come from a warm grey seed so
    // backgrounds read as paper, not pink.
    final accents = ColorScheme.fromSeed(
      seedColor: AppColors.red,
      brightness: brightness,
    );
    final neutrals = ColorScheme.fromSeed(
      seedColor: AppColors.warmGrey,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    );
    final scheme = accents.copyWith(
      primary: isLight ? AppColors.red : null,
      onPrimary: isLight ? Colors.white : null,
      surface: neutrals.surface,
      onSurface: neutrals.onSurface,
      onSurfaceVariant: neutrals.onSurfaceVariant,
      surfaceContainerLowest: neutrals.surfaceContainerLowest,
      surfaceContainerLow: neutrals.surfaceContainerLow,
      surfaceContainer: neutrals.surfaceContainer,
      surfaceContainerHigh: neutrals.surfaceContainerHigh,
      surfaceContainerHighest: neutrals.surfaceContainerHighest,
      outline: neutrals.outline,
      outlineVariant: neutrals.outlineVariant,
      secondaryContainer: neutrals.secondaryContainer,
      onSecondaryContainer: neutrals.onSecondaryContainer,
    );
    // Paper: the page background behind every screen.
    final paper = isLight ? scheme.surfaceContainerLow : scheme.surface;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
    );
    final textTheme = _textTheme(base.textTheme);
    final group = groupColor(base);
    const buttonSize = Size(64, 48);

    return base.copyWith(
      scaffoldBackgroundColor: paper,
      canvasColor: paper,
      textTheme: textTheme,
      appBarTheme: AppBarThemeData(
        backgroundColor: paper,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: StatusBarStyle.onPage(brightness),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: group,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.group),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: Space.l),
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        space: 1,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: textTheme.labelLarge),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          selectedBackgroundColor: scheme.secondaryContainer,
          selectedForegroundColor: scheme.onSecondaryContainer,
          textStyle: textTheme.labelLarge,
        ).copyWith(minimumSize: const WidgetStatePropertyAll(Size(0, 48))),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        thumbColor: scheme.primary,
        inactiveTrackColor: scheme.primary.withValues(alpha: 0.2),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: group,
        showDragHandle: true,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  /// Four sizes (28, 20, 16, 13) and two weights (400, 600). Titles use the
  /// serif; everything else keeps the platform font.
  static TextTheme _textTheme(TextTheme base) {
    TextStyle style(
      TextStyle? from,
      double size,
      FontWeight weight, {
      double height = 1.4,
      String? family,
    }) => from!.copyWith(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: 0,
      fontFamily: family,
    );

    final headline = style(
      base.headlineSmall,
      28,
      FontWeight.w600,
      height: 1.2,
      family: AppFonts.serif,
    );
    return base.copyWith(
      headlineLarge: headline,
      headlineMedium: headline,
      headlineSmall: headline,
      titleLarge: style(
        base.titleLarge,
        20,
        FontWeight.w600,
        height: 1.3,
        family: AppFonts.serif,
      ),
      titleMedium: style(base.titleMedium, 16, FontWeight.w600, height: 1.35),
      titleSmall: style(base.titleSmall, 13, FontWeight.w600),
      bodyLarge: style(base.bodyLarge, 16, FontWeight.w400, height: 1.5),
      bodyMedium: style(base.bodyMedium, 16, FontWeight.w400, height: 1.5),
      bodySmall: style(base.bodySmall, 13, FontWeight.w400),
      labelLarge: style(base.labelLarge, 16, FontWeight.w600, height: 1.25),
      labelMedium: style(base.labelMedium, 13, FontWeight.w600),
      labelSmall: style(base.labelSmall, 13, FontWeight.w400),
    );
  }
}
