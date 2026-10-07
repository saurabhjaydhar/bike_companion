import 'package:flutter/material.dart';

/// Garajo palette. Dark ("Night Ride"): an instrument cluster — near-black
/// panels, cyan HUD accent and neon status colours. Light ("Paddock"): warm
/// paper, white panels, carbon-black heroes. Ignition orange is the brand
/// colour in both.
class AppColors {
  // Primary — ignition orange
  static const Color primary = Color(0xFFFF5A1F);
  static const Color primaryLight = Color(0xFFFF7A45);
  static const Color primaryDark = Color(0xFFE23D0B);

  // HUD accent — used for data highlights and glows
  static const Color accent = Color(0xFF2CE5FF);

  /// The accent darkened for text and icons on light surfaces, where the
  /// neon cyan is too pale to read.
  static const Color accentInk = Color(0xFF0891B2);

  /// Picks [accent] or [accentInk] for the current brightness.
  static Color accentFor(bool isDark) => isDark ? accent : accentInk;

  // Semantic — light mode
  static const Color success = Color(0xFF00B377);
  static const Color warning = Color(0xFFF29D00);
  static const Color danger = Color(0xFFF0284A);

  // Semantic — dark mode (neon, for visibility on black)
  static const Color successDark = Color(0xFF2BF5A0);
  static const Color warningDark = Color(0xFFFFC233);
  static const Color dangerDark = Color(0xFFFF4D6A);

  // Surface — light ("Paddock"): warm paper page, crisp white panels with a
  // fine border, near-black ink. Depth comes from borders and a tight
  // shadow, not soft blur; the hero uses [carbon].
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF7F6F2);
  static const Color background = Color(0xFFF3F2EE);
  static const Color border = Color(0xFFDCDAD3);

  /// Unfilled tracks (progress bars, gauge segments, idle chart bars) —
  /// a step darker than [border] so they read against white.
  static const Color track = Color(0xFFE4E2DC);

  /// Warm ink used to tint light-mode shadows and the page texture.
  static const Color shadow = Color(0xFF1A1712);
  static const Color textPrimary = Color(0xFF111214);
  static const Color textSecondary = Color(0xFF5C5F66);
  static const Color textTertiary = Color(0xFF9A9CA2);

  /// Carbon-black surface for hero panels and the nav bar in light mode —
  /// the "fairing" that anchors each page.
  static const Color carbon = Color(0xFF111214);
  static const Color carbonEdge = Color(0xFF26282E);

  // Surface — dark
  static const Color surfaceDark = Color(0xFF11141B);
  static const Color surfaceVariantDark = Color(0xFF181C25);
  static const Color backgroundDark = Color(0xFF07080C);
  static const Color borderDark = Color(0xFF242936);
  static const Color trackDark = Color(0xFF242936);
  static const Color textPrimaryDark = Color(0xFFF3F5F9);
  static const Color textSecondaryDark = Color(0xFF9AA3B5);
  static const Color textTertiaryDark = Color(0xFF5E6678);

  // Primary action gradient (throttle → redline)
  static const List<Color> ignitionGradient = [
    Color(0xFFFF7A2F),
    Color(0xFFFF3D3D),
  ];

  // Stat tile tints — one per quick stat so a grid of them isn't uniform
  static const Color statFuel = Color(0xFFFF5A1F);
  static const Color statService = Color(0xFF00B377);
  static const Color statCost = Color(0xFF7C5CFF);
  static const Color statOdometer = Color(0xFF0891B2);

  // Vehicle avatar colour presets
  static const List<Color> vehicleColors = [
    Color(0xFF1A56DB), // Blue
    Color(0xFFEF4444), // Red
    Color(0xFF0E9F6E), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF06B6D4), // Cyan
    Color(0xFF111827), // Black
  ];
}
