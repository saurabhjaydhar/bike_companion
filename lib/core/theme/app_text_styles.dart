import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type for a motorsport look:
/// - Saira Condensed for headings, labels and big readouts — tall, narrow
///   and fast, like livery lettering.
/// - Saira for body text — the same family, so the two sit together.
/// - JetBrains Mono for data (km, ₹, days) — fixed-width digits that line up
///   like a telemetry readout.
/// Scripts these fonts don't cover (Devanagari, Arabic) fall back to the
/// platform font automatically.
class AppTextStyles {
  static TextStyle get display => GoogleFonts.sairaCondensed(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        height: 1.05,
      );

  static TextStyle get heading1 => GoogleFonts.sairaCondensed(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        height: 1.1,
      );

  static TextStyle get heading2 => GoogleFonts.sairaCondensed(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        height: 1.15,
      );

  static TextStyle get heading3 => GoogleFonts.sairaCondensed(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        height: 1.25,
      );

  /// Large readouts — the health score, money totals.
  static TextStyle get metric => GoogleFonts.sairaCondensed(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.0,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Data values — km, ₹, days — in a monospaced telemetry face.
  static TextStyle get data => GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.15,
      );

  static TextStyle get body => GoogleFonts.saira(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.saira(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get bodySemiBold => GoogleFonts.saira(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.saira(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.1,
      );

  static TextStyle get captionMedium => GoogleFonts.saira(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get label => GoogleFonts.sairaCondensed(
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        height: 1.35,
      );
}
