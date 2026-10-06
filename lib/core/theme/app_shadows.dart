import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Elevation for cards and floating surfaces.
///
/// Light mode gets its depth from two navy-tinted layers: a tight contact
/// shadow that defines the edge and a soft ambient one that lifts the card
/// off the page. Dark mode relies on borders and glows instead, since
/// shadows don't show on near-black.
class AppShadows {
  /// Resting cards.
  static List<BoxShadow> card(bool isDark) => isDark
      ? const []
      : [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.13),
            blurRadius: 24,
            spreadRadius: -6,
            offset: const Offset(0, 10),
          ),
        ];

  /// Surfaces that sit above cards — selected chips, the nav bar.
  static List<BoxShadow> raised(bool isDark) => isDark
      ? const []
      : [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: -6,
            offset: const Offset(0, 12),
          ),
        ];

  /// A coloured glow under a card — a status or vehicle colour.
  static BoxShadow glow(Color colour, bool isDark) => BoxShadow(
    color: colour.withValues(alpha: isDark ? 0.22 : 0.20),
    blurRadius: isDark ? 24 : 28,
    spreadRadius: -6,
    offset: Offset(0, isDark ? 8 : 12),
  );

  /// Claymorphic lift for light mode: a white highlight up and to the left
  /// and a soft navy shadow down and to the right, as if lit from above.
  static List<BoxShadow> clay(bool isDark) => isDark
      ? const []
      : [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.9),
            blurRadius: 16,
            offset: const Offset(-6, -6),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.16),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(6, 12),
          ),
        ];
}
