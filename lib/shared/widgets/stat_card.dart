import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'clay_icon.dart';
import 'hud_panel.dart';

/// A compact instrument readout: label, a prominent value and optional trend.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool trendPositive;
  final IconData? icon;

  /// Tints the icon tile. Defaults to the HUD accent.
  final Color? color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final trendColor = trendPositive
        ? (isDark ? AppColors.successDark : AppColors.success)
        : (isDark ? AppColors.dangerDark : AppColors.danger);
    final tint = color ?? AppColors.accentFor(isDark);

    return HudPanel(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                ClayIcon(icon: icon!, color: tint, size: 32),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(color: textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTextStyles.data.copyWith(
              color: textPrimary,
              fontSize: 19,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (trend != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(
                  trendPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 13,
                  color: trendColor,
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    trend!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTextStyles.captionMedium.copyWith(color: trendColor),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
