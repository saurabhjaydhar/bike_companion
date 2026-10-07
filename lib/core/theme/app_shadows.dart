import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Elevation for cards and floating surfaces.
///
/// Light mode: a tight, crisp shadow in warm ink — panels look machined
/// rather than puffy. Dark mode relies on borders and glows instead, since
/// shadows don't show on near-black.
class AppShadows {
  /// Resting cards.
  static List<BoxShadow> card(bool isDark) => isDark
      ? const []
      : [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 14,
            spreadRadius: -6,
            offset: const Offset(0, 6),
          ),
        ];

  /// Surfaces that sit above cards — selected chips, the nav bar, heroes.
  static List<BoxShadow> raised(bool isDark) => isDark
      ? const []
      : [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.10),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.18),
            blurRadius: 22,
            spreadRadius: -8,
            offset: const Offset(0, 12),
          ),
        ];

  /// A coloured glow under a card — a status or vehicle colour.
  static BoxShadow glow(Color colour, bool isDark) => BoxShadow(
    color: colour.withValues(alpha: isDark ? 0.22 : 0.16),
    blurRadius: isDark ? 24 : 18,
    spreadRadius: -6,
    offset: Offset(0, isDark ? 8 : 8),
  );

  /// Standard panel elevation — same as [card]; kept as the name panels use.
  static List<BoxShadow> panel(bool isDark) => card(isDark);
}
