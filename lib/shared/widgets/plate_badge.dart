import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Registration number styled like a number plate. Always left-to-right.
class PlateBadge extends StatelessWidget {
  final String number;
  final double fontSize;

  const PlateBadge(this.number, {super.key, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: fontSize * 0.6, vertical: fontSize * 0.2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B0D12) : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isDark ? AppColors.textTertiaryDark : AppColors.textPrimary,
          width: 1.2,
        ),
      ),
      child: Text(
        number,
        textDirection: TextDirection.ltr,
        maxLines: 1,
        style: GoogleFonts.jetBrainsMono(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          height: 1.2,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
    );
  }
}
