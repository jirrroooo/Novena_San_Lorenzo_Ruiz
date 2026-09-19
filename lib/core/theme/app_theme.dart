import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Brand palette shared by the app, the native splash and the header art.
///
/// A soft pastel red (a gentle nod to the liturgical red of martyrs) is the
/// accent, used sparingly; surfaces stay neutral so long reading is easy on
/// the eyes. Gold echoes the halo in the launcher icon artwork.
abstract final class AppColors {
  /// Pastel red used for headers, the splash and filled accents.
  static const Color rose = Color(0xFFE56B6F);

  /// Slightly deeper pastel red for text and icons so they stay legible.
  static const Color roseInk = Color(0xFFD4555C);
  static const Color gold = Color(0xFFD8B86A);

  /// Warm grey used to derive neutral (non-pink) surfaces.
  static const Color warmGrey = Color(0xFF8A817C);

  /// Collapsed app bar background (pastel red in light mode, charcoal in dark).
  static const Color header = rose;
  static const Color nightHeader = Color(0xFF2C2728);
}

abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    // Accent colours come from the pastel red seed ("fidelity" keeps them
    // close to it instead of greying them out); surfaces come from a warm grey
    // seed so backgrounds are not tinted pink.
    final accents = ColorScheme.fromSeed(
      seedColor: AppColors.rose,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final isLight = brightness == Brightness.light;
    final neutrals = ColorScheme.fromSeed(
      seedColor: AppColors.warmGrey,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    );
    final scheme = accents.copyWith(
      primary: isLight ? AppColors.roseInk : null,
      onPrimary: isLight ? Colors.white : null,
      primaryContainer: isLight ? const Color(0xFFFFDEDC) : null,
      onPrimaryContainer: isLight ? const Color(0xFF7A2428) : null,
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
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarThemeData(
        backgroundColor: isDark ? AppColors.nightHeader : AppColors.header,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        // Only icon brightness is set: colours are left to the edge-to-edge
        // window so no deprecated status/navigation bar colour APIs are hit.
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        iconColor: scheme.onSurfaceVariant,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.7),
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.primaryContainer.withValues(alpha: 0.7),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          selectedBackgroundColor: scheme.secondaryContainer,
          selectedForegroundColor: scheme.onSecondaryContainer,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        thumbColor: scheme.primary,
        inactiveTrackColor: scheme.primary.withValues(alpha: 0.2),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        showDragHandle: true,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
