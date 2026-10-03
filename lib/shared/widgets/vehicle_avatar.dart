import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle_type.dart';

/// Glowing tile with a vehicle icon, tinted with the vehicle's colour.
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colour.withValues(alpha: 0.35),
            colour.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: colour.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: colour.withValues(alpha: 0.35),
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
              color: Color.lerp(colour, Colors.white, 0.35),
              size: size * 0.55,
            ),
    );
  }
}
