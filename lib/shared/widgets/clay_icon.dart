import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// An icon on a rounded tile. In light mode the tile is solid "clay": a
/// gradient of the colour, a glossy highlight across the top and a coloured
/// shadow beneath, with a white icon. In dark mode it is a tinted glass tile
/// with the icon in the colour, matching the neon look.
class ClayIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const ClayIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(size * 0.3);
    final iconSize = size * 0.5;

    if (isDark) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.24),
              color.withValues(alpha: 0.08),
            ],
          ),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Icon(icon, size: iconSize, color: color),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, Colors.white, 0.28)!, color],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.38),
            blurRadius: size * 0.32,
            spreadRadius: -size * 0.06,
            offset: Offset(0, size * 0.14),
          ),
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gloss: a soft white sheen over the top half.
          Positioned(
            left: 2,
            right: 2,
            top: 2,
            height: size * 0.48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.26),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.45),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Color.lerp(color, Colors.black, 0.4)!
                      .withValues(alpha: 0.35),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
