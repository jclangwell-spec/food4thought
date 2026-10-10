import 'package:flutter/material.dart';

/// The "Ember" palette Josh picked: white cards on light grey, one
/// blood-orange accent. Every screen takes its colours from here.
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
  );

  static const dark = AppColors(
    background: Color(0xFF0F1114),
    card: Color(0xFF1A1D22),
    ink: Color(0xFFF1F2F4),
    inkSecondary: Color(0xFF9DA2AD),
    line: Color(0xFF2A2E35),
    accent: Color(0xFFE5482A),
    onAccent: Color(0xFFFFFFFF),
    accentText: Color(0xFFFF7A5C),
    accentSoft: Color(0xFF5A2C22),
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
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
