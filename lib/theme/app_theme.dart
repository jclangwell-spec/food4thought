import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Barlow for text, Barlow Condensed for headings and big numbers.
class AppFonts {
  static const body = 'Barlow';
  static const condensed = 'Barlow Condensed';
}

class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);
  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: c.accent,
          brightness: brightness,
        ).copyWith(
          primary: c.accent,
          onPrimary: c.onAccent,
          surface: c.card,
          onSurface: c.ink,
          onSurfaceVariant: c.inkSecondary,
          outlineVariant: c.line,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.body,
      scaffoldBackgroundColor: c.background,
      extensions: [c],
    );

    TextStyle condensed(double size, FontWeight weight) => TextStyle(
      fontFamily: AppFonts.condensed,
      fontSize: size,
      fontWeight: weight,
      height: 1.05,
      color: c.ink,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        // Big stat numbers.
        displaySmall: condensed(28, FontWeight.w700),
        // Restaurant names on cards.
        headlineSmall: condensed(26, FontWeight.w700),
        // Section headings like "Popular this week" and "Browse by".
        titleLarge: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: c.ink,
        ),
        // Small spaced-out labels like "FAVOURITES".
        titleSmall: TextStyle(
          fontFamily: AppFonts.body,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
          color: c.inkSecondary,
        ),
        // Uppercase titles in sheets, like "WRITE A REVIEW".
        titleMedium: condensed(
          18,
          FontWeight.w700,
        ).copyWith(letterSpacing: 0.4),
        bodyLarge: TextStyle(fontSize: 16, height: 1.4, color: c.ink),
        bodyMedium: TextStyle(fontSize: 15, height: 1.4, color: c.ink),
        bodySmall: TextStyle(fontSize: 13, height: 1.3, color: c.inkSecondary),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: c.inkSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bar,
        foregroundColor: c.ink,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
