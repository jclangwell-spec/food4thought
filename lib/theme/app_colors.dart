import 'package:flutter/material.dart';

/// The Ember accent on a Letterboxd-style dark slate. The app runs in
/// [dark] by default; [light] is kept for a later light mode. Every screen
/// takes its colours from here.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.card,
    required this.ink,
    required this.inkSecondary,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.accentText,
    required this.accentSoft,
    required this.bar,
    required this.field,
    required this.fieldSelected,
  });

  /// Page background behind the cards.
  final Color background;
  final Color card;

  /// Main text.
  final Color ink;

  /// Labels, captions and inactive icons.
  final Color inkSecondary;

  /// Hairline dividers.
  final Color line;

  /// Fills: the + button, the top chart bar, filled stars.
  final Color accent;
  final Color onAccent;

  /// Accent used for small text, darkened so it passes WCAG AA contrast.
  final Color accentText;

  /// Pale accent for secondary chart bars and highlights.
  final Color accentSoft;

  /// Top bar behind screen titles, and the bottom tab bar.
  final Color bar;

  /// Search box, segmented tabs and empty tiles.
  final Color field;

  /// The selected segment in segmented tabs.
  final Color fieldSelected;

  static const light = AppColors(
    background: Color(0xFFF2F3F5),
    card: Color(0xFFFFFFFF),
    ink: Color(0xFF1E1E24),
    inkSecondary: Color(0xFF63676F),
    line: Color(0xFFE3E5E9),
    accent: Color(0xFFE5482A),
    onAccent: Color(0xFFFFFFFF),
    accentText: Color(0xFFC2381C),
    accentSoft: Color(0xFFF6C9BE),
    bar: Color(0xFFFFFFFF),
    field: Color(0xFFE7EAEE),
    fieldSelected: Color(0xFFFFFFFF),
  );

  static const dark = AppColors(
    background: Color(0xFF161A1F),
    card: Color(0xFF1D2329),
    ink: Color(0xFFEEF1F4),
    inkSecondary: Color(0xFF98A3AF),
    line: Color(0xFF29313A),
    accent: Color(0xFFE5482A),
    onAccent: Color(0xFFFFFFFF),
    accentText: Color(0xFFFF7A5C),
    accentSoft: Color(0xFF5A2C22),
    bar: Color(0xFF0C0F12),
    field: Color(0xFF2B333C),
    fieldSelected: Color(0xFF4A5764),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? card,
    Color? ink,
    Color? inkSecondary,
    Color? line,
    Color? accent,
    Color? onAccent,
    Color? accentText,
    Color? accentSoft,
    Color? bar,
    Color? field,
    Color? fieldSelected,
  }) {
    return AppColors(
      background: background ?? this.background,
      card: card ?? this.card,
      ink: ink ?? this.ink,
      inkSecondary: inkSecondary ?? this.inkSecondary,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentText: accentText ?? this.accentText,
      accentSoft: accentSoft ?? this.accentSoft,
      bar: bar ?? this.bar,
      field: field ?? this.field,
      fieldSelected: fieldSelected ?? this.fieldSelected,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkSecondary: Color.lerp(inkSecondary, other.inkSecondary, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      bar: Color.lerp(bar, other.bar, t)!,
      field: Color.lerp(field, other.field, t)!,
      fieldSelected: Color.lerp(fieldSelected, other.fieldSelected, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
