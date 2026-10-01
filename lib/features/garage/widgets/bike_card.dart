import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/l10n.dart';
import '../../../data/models/health_score.dart';
import '../../../shared/widgets/bike_avatar.dart';
import '../garage_provider.dart';

class BikeCard extends StatelessWidget {
  final GarageItem item;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const BikeCard({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  Color _gradeColor(HealthGrade grade, bool isDark) {
    switch (grade) {
      case HealthGrade.excellent:
      case HealthGrade.good:
        return isDark ? AppColors.successDark : AppColors.success;
      case HealthGrade.fair:
        return isDark ? AppColors.warningDark : AppColors.warning;
      case HealthGrade.poor:
      case HealthGrade.critical:
        return isDark ? AppColors.dangerDark : AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final scoreColor = _gradeColor(item.healthScore.grade, isDark);
    final rupeeFormat = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: AnimatedContainer(
        duration: AppDuration.fast,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border(
            left: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
            right: BorderSide(color: border),
            top: BorderSide(color: border),
            bottom: BorderSide(color: border),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              BikeAvatar(colour: item.bike.colour, size: 48),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.bike.name,
                            style: AppTextStyles.bodySemiBold
                                .copyWith(color: textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.hasAlerts)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.warningDark
                                  : AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.bike.brand} ${item.bike.model}  ·  ${item.bike.regNumber}',
                      style:
                          AppTextStyles.caption.copyWith(color: textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(Icons.speed_rounded,
                            size: 12, color: textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${NumberFormat('#,##,###').format(item.bike.odometerCurrent)} km',
                          style: AppTextStyles.caption
                              .copyWith(color: textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.healthScore.score}%',
                    style: AppTextStyles.heading3.copyWith(color: scoreColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rupeeFormat.format(item.monthTotal),
                    style:
                        AppTextStyles.caption.copyWith(color: textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.commonThisMonth,
                    style:
                        AppTextStyles.label.copyWith(color: textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              title: Text(context.l10n.garageDeleteBike(item.bike.name),
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.danger)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.garageDeleteBikeTitle(item.bike.name)),
        content: Text(context.l10n.garageDeleteBikeBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.commonCancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(context.l10n.commonDelete,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}
