import 'package:flutter/material.dart';

/// An icon on a rounded tile. In light mode the tile is a flat, solid block
/// of the colour with a white icon, like a livery decal. In dark mode it is a
/// tinted glass tile with the icon in the colour, matching the neon look.
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

    // Light: a flat, solid tile with a white icon — decal-like, no gloss.
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.24),
      ),
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }
}
