import 'package:flutter/material.dart';

/// "Night Ride" palette — an instrument-cluster look: near-black panels,
/// ignition-orange primary, cyan HUD accent and neon status colours.
class AppColors {
  // Primary — ignition orange
  static const Color primary = Color(0xFFFF5A1F);
  static const Color primaryLight = Color(0xFFFF7A45);
  static const Color primaryDark = Color(0xFFE23D0B);

  // HUD accent — used for data highlights and glows
  static const Color accent = Color(0xFF2CE5FF);

  // Semantic — light mode
  static const Color success = Color(0xFF00B377);
  static const Color warning = Color(0xFFF29D00);
  static const Color danger = Color(0xFFF0284A);

  // Semantic — dark mode (neon, for visibility on black)
  static const Color successDark = Color(0xFF2BF5A0);
  static const Color warningDark = Color(0xFFFFC233);
  static const Color dangerDark = Color(0xFFFF4D6A);

  // Surface — light
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F6F9);
  static const Color background = Color(0xFFEDEFF3);
  static const Color border = Color(0xFFDFE2EA);
  static const Color textPrimary = Color(0xFF0B0E14);
  static const Color textSecondary = Color(0xFF5A6273);
  static const Color textTertiary = Color(0xFF949CAD);

  // Surface — dark
  static const Color surfaceDark = Color(0xFF11141B);
  static const Color surfaceVariantDark = Color(0xFF181C25);
  static const Color backgroundDark = Color(0xFF07080C);
  static const Color borderDark = Color(0xFF242936);
  static const Color textPrimaryDark = Color(0xFFF3F5F9);
  static const Color textSecondaryDark = Color(0xFF9AA3B5);
  static const Color textTertiaryDark = Color(0xFF5E6678);

  // Primary action gradient (throttle → redline)
  static const List<Color> ignitionGradient = [
    Color(0xFFFF7A2F),
    Color(0xFFFF3D3D),
  ];

  // Bike avatar colour presets
  static const List<Color> bikeColors = [
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
