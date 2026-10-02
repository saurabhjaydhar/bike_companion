import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Headings, labels and numbers use Chakra Petch — a squared, instrument-panel
/// face. Body text stays in Inter for readability. Scripts these fonts don't
/// cover (Devanagari, Arabic) fall back to the platform font automatically.
class AppTextStyles {
  static TextStyle get display => GoogleFonts.chakraPetch(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.15,
      );

  static TextStyle get heading1 => GoogleFonts.chakraPetch(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.25,
      );

  static TextStyle get heading2 => GoogleFonts.chakraPetch(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get heading3 => GoogleFonts.chakraPetch(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        height: 1.35,
      );

  /// Large numeric readouts (scores, money, odometer).
  static TextStyle get metric => GoogleFonts.chakraPetch(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.1,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get bodySemiBold => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.1,
      );

  static TextStyle get captionMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get label => GoogleFonts.chakraPetch(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.9,
        height: 1.4,
      );
}
