import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'hud_panel.dart';

/// A compact telemetry readout: a small uppercase label over a big
/// monospaced value, with an optional trend line. [emphasis] paints the value
/// in ignition orange to draw the eye (e.g. the next service).
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final bool trendPositive;
  final bool emphasis;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.trendPositive = true,
    this.emphasis = false,
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

    return HudPanel(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md + 2, AppSpacing.md, AppSpacing.md + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(
              color: textSecondary,
              fontSize: 11.5,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value.toUpperCase(),
            style: AppTextStyles.data.copyWith(
              color: emphasis ? AppColors.primary : textPrimary,
              fontSize: 22,
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
