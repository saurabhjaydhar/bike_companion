import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/vehicle_avatar.dart';
import '../../../shared/widgets/health_ring.dart';
import '../../../shared/widgets/hud_panel.dart';
import '../../../shared/widgets/plate_badge.dart';
import '../../../core/services/reminder_planner.dart';
import '../garage_provider.dart';

class VehicleCard extends StatelessWidget {
  final GarageItem item;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const VehicleCard({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final track = isDark ? AppColors.trackDark : AppColors.track;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final scoreColor =
        HealthRing.gradeColor(item.healthScore.grade, isDark: isDark);
    final rupeeFormat = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final score = item.healthScore.score;

    return HudPanel(
      glow: isActive ? AppColors.primary : null,
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: Column(
        children: [
          Row(
            children: [
              VehicleAvatar(
                colour: item.vehicle.colour,
                size: 52,
                type: item.vehicle.type,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.vehicle.name,
                            style: AppTextStyles.heading3
                                .copyWith(color: textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.hasAlerts) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.warningDark
                                  : AppColors.warning,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                    color: AppColors.warningDark,
                                    blurRadius: 6),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${item.vehicle.brand} ${item.vehicle.model}',
                      style:
                          AppTextStyles.caption.copyWith(color: textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    PlateBadge(item.vehicle.regNumber, fontSize: 10),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$score%',
                    style: AppTextStyles.metric.copyWith(
                      color: scoreColor,
                      fontSize: 26,
                      shadows: [
                        Shadow(
                            color: scoreColor.withValues(alpha: 0.5),
                            blurRadius: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rupeeFormat.format(item.monthTotal),
                    style: AppTextStyles.bodySemiBold
                        .copyWith(color: textPrimary),
                  ),
                  Text(
                    context.l10n.commonThisMonth,
                    style:
                        AppTextStyles.label.copyWith(color: textSecondary),
                  ),
                ],
              ),
              // Visible way into edit/delete (long-press still works).
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32),
                icon: Icon(Icons.more_vert_rounded, color: textSecondary),
                onPressed: () => _showOptions(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Health bar, styled like a segmented fuel gauge
          Row(
            children: [
              Icon(Icons.speed_rounded, size: 14, color: textSecondary),
              const SizedBox(width: 4),
              Text(
                '${NumberFormat('#,##,###').format(item.vehicle.odometerCurrent)} km',
                style: AppTextStyles.label.copyWith(color: textSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Row(
                  children: [
                    for (var i = 0; i < 10; i++)
                      Expanded(
                        child: Container(
                          height: 6,
                          margin: const EdgeInsetsDirectional.only(end: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1.5),
                            color: i < (score / 10).round()
                                ? scoreColor
                                : track,
                            boxShadow: [
                              if (i < (score / 10).round())
                                BoxShadow(
                                    color: scoreColor.withValues(alpha: 0.5),
                                    blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (item.nextDue case final due?) ...[
            const SizedBox(height: AppSpacing.sm),
            _NextDue(item: due),
          ],
        ],
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
        child: SingleChildScrollView(
         child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.borderDark
                    : AppColors.track,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(context.l10n.vehicleEditTitle,
                  style: AppTextStyles.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger),
              title: Text(context.l10n.garageDeleteVehicle(item.vehicle.name),
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
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.garageDeleteVehicleTitle(item.vehicle.name)),
        content: Text(context.l10n.garageDeleteVehicleBody),
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

/// The soonest date to act on, colour-coded like the dashboard's
/// "Coming up" card.
class _NextDue extends StatelessWidget {
  final DueItem item;
  const _NextDue({required this.item});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    final days = item.daysLeft(now);
    final colour = days <= 7
        ? AppColors.danger
        : days <= 30
            ? AppColors.warning
            : AppColors.success;
    final when = days > 60
        ? DateFormat.yMMMd(l.localeName).format(item.due)
        : l.dueWhen(item, now);

    return Row(
      children: [
        Icon(Icons.event_note_rounded, size: 14, color: colour),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '${l.dueItemLabel(item)} · $when',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label.copyWith(color: colour),
          ),
        ),
      ],
    );
  }
}
