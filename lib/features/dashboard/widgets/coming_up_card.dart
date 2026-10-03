import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/reminder_planner.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/health_score.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/hud_panel.dart';
import '../dashboard_provider.dart';

/// "Coming up": the next few things to act on for this vehicle — expiries,
/// service dates and service items needing attention — most urgent first,
/// each one tap away from fixing.
class ComingUpCard extends StatelessWidget {
  final DashboardState dash;

  /// Opens the date editor for one of the vehicle's own dates.
  final void Function(DueKind kind) onEditDate;

  /// Asks for notification permission again.
  final VoidCallback onTurnOnReminders;

  const ComingUpCard({
    super.key,
    required this.dash,
    required this.onEditDate,
    required this.onTurnOnReminders,
  });

  static const _maxRows = 3;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final rows = _rows(context).take(_maxRows).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: HudPanel(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_note_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(l.comingUpTitle,
                      style:
                          AppTextStyles.heading3.copyWith(color: textPrimary)),
                ),
                if (!dash.remindersPermitted)
                  TextButton.icon(
                    onPressed: onTurnOnReminders,
                    icon: const Icon(Icons.notifications_off_outlined,
                        size: 18),
                    label: Text(l.remindersTurnOn),
                  ),
              ],
            ),
            if (!dash.remindersPermitted)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Text(l.remindersOffBody,
                    style:
                        AppTextStyles.caption.copyWith(color: textSecondary)),
              )
            else if (dash.remindersMuted)
              Text(l.remindersMutedNote,
                  style: AppTextStyles.caption.copyWith(color: textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            if (rows.isEmpty)
              _Row(
                icon: Icons.check_circle_rounded,
                colour: AppColors.success,
                label: l.comingUpEmpty,
              )
            else
              ...rows,
          ],
        ),
      ),
    );
  }

  /// All rows, most urgent first.
  List<_Row> _rows(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now();
    final ranked = <(int, DateTime, _Row)>[];

    for (final item in dash.dueItems) {
      final days = item.daysLeft(now);
      final (rank, colour) = days <= 7
          ? (0, AppColors.danger)
          : days <= 30
              ? (1, AppColors.warning)
              : (3, AppColors.success);
      ranked.add((
        rank,
        item.due,
        _Row(
          icon: _icon(item.kind),
          colour: colour,
          label: l.dueItemLabel(item),
          // Far-off dates read better as a date than "in 512 days".
          trailing: days > 60
              ? DateFormat.yMMMd(l.localeName).format(item.due)
              : l.dueWhen(item, now),
          onTap: () => item.isVehicleDate
              ? onEditDate(item.kind)
              : context.go(item.kind == DueKind.service
                  ? '/service/${item.vehicleId}'
                  : '/documents/${item.vehicleId}'),
        ),
      ));
    }

    // Prompt for the dates every vehicle needs.
    for (final (kind, date) in [
      (DueKind.insurance, dash.vehicle.insuranceExpiry),
      (DueKind.puc, dash.vehicle.pucExpiry),
    ]) {
      if (date != null) continue;
      ranked.add((
        2,
        now,
        _Row(
          icon: _icon(kind),
          colour: AppColors.accent,
          label: kind == DueKind.insurance ? l.docInsurance : l.docPuc,
          trailing: l.dueAddDate,
          onTap: () => onEditDate(kind),
        ),
      ));
    }

    for (final f in dash.healthScore.factors) {
      if (f.serviceType == null || f.status == HealthStatus.good) continue;
      final overdue = f.status == HealthStatus.danger;
      ranked.add((
        overdue ? 0 : 1,
        now,
        _Row(
          icon: Icons.build_rounded,
          colour: overdue ? AppColors.danger : AppColors.warning,
          label: l.serviceTypeLabel(f.serviceType!),
          trailing: overdue ? l.dueServiceOverdue : l.dueServiceSoon,
          onTap: () => context.go('/service/${dash.vehicle.id}'),
        ),
      ));
    }

    ranked.sort((a, b) {
      final byRank = a.$1.compareTo(b.$1);
      return byRank != 0 ? byRank : a.$2.compareTo(b.$2);
    });
    return [for (final r in ranked) r.$3];
  }

  static IconData _icon(DueKind kind) => switch (kind) {
    DueKind.insurance => Icons.verified_rounded,
    DueKind.puc => Icons.eco_rounded,
    DueKind.registration => Icons.badge_outlined,
    DueKind.licence => Icons.badge_rounded,
    DueKind.document => Icons.insert_drive_file_rounded,
    DueKind.service => Icons.build_rounded,
  };
}

class _Row extends StatelessWidget {
  final IconData icon;
  final Color colour;
  final String label;
  final String? trailing;
  final VoidCallback? onTap;

  const _Row({
    required this.icon,
    required this.colour,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.selectionClick();
              onTap!();
            },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Row(
            children: [
              Icon(icon, color: colour, size: 20),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTextStyles.bodyMedium.copyWith(color: textPrimary)),
              ),
              if (trailing != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: colour.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(trailing!,
                      style: AppTextStyles.caption.copyWith(
                          color: colour, fontWeight: FontWeight.w700)),
                ),
              if (onTap != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.chevron_right_rounded,
                    size: 18, color: colour.withValues(alpha: 0.7)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
