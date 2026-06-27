import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_text_styles.dart';

/// Rounded square avatar with a bike icon, coloured by the bike's theme colour.
class BikeAvatar extends StatelessWidget {
  final Color colour;
  final double size;
  final String? initials;

  const BikeAvatar({
    super.key,
    required this.colour,
    this.size = 48,
    this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(
          color: colour.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: initials != null
          ? Center(
              child: Text(
                initials!,
                style: AppTextStyles.bodySemiBold.copyWith(
                  color: colour,
                  fontSize: size * 0.3,
                ),
              ),
            )
          : Icon(
              Icons.two_wheeler_rounded,
              color: colour,
              size: size * 0.5,
            ),
    );
  }
}
