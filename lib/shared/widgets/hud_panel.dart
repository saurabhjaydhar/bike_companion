import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// Glassy instrument-panel surface: a subtle top-lit gradient, a hairline
/// border, and an optional coloured glow (e.g. a status or vehicle colour).
class HudPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? glow;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const HudPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.glow,
    this.radius = AppRadius.large,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final shape = BorderRadius.circular(radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: [
          if (glow != null)
            BoxShadow(
              color: glow!.withValues(alpha: isDark ? 0.22 : 0.16),
              blurRadius: 24,
              spreadRadius: -6,
              offset: const Offset(0, 8),
            ),
          if (!isDark)
            const BoxShadow(
              color: Color(0x0F0B0E14),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: shape,
            border: Border.all(
              color: glow != null
                  ? Color.alphaBlend(glow!.withValues(alpha: 0.35), border)
                  : border,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      Color.alphaBlend(
                          Colors.white.withValues(alpha: 0.04), surface),
                      surface,
                    ]
                  : [surface, surface],
            ),
          ),
          child: InkWell(
            borderRadius: shape,
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
