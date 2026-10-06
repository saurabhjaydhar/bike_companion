import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle_type.dart';
import 'clay_icon.dart';

/// Tile with a vehicle icon in the vehicle's colour: a glowing glass tile
/// in dark mode, solid clay in light mode.
class VehicleAvatar extends StatelessWidget {
  final Color colour;
  final double size;
  final String? initials;

  /// Picks the icon: two-wheeler, moped or car.
  final VehicleType type;

  const VehicleAvatar({
    super.key,
    required this.colour,
    this.size = 48,
    this.initials,
    this.type = VehicleType.bike,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isDark && initials == null) {
      return ClayIcon(icon: type.icon, color: colour, size: size);
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colour.withValues(alpha: isDark ? 0.35 : 0.22),
            colour.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
            color: colour.withValues(alpha: isDark ? 0.55 : 0.35)),
        boxShadow: [
          BoxShadow(
            color: colour.withValues(alpha: isDark ? 0.35 : 0.25),
            blurRadius: size * 0.35,
            spreadRadius: -size * 0.12,
          ),
        ],
      ),
      child: initials != null
          ? Center(
              child: Text(
                initials!,
                style: AppTextStyles.heading3.copyWith(
                  color: Colors.white,
                  fontSize: size * 0.32,
                ),
              ),
            )
          : Icon(
              type.icon,
              // Lightened to glow on black; darkened to read on white.
              color: isDark
                  ? Color.lerp(colour, Colors.white, 0.35)
                  : Color.lerp(colour, Colors.black, 0.1),
              size: size * 0.55,
            ),
    );
  }
}
