import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/health_score.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/health_ring.dart';

/// What a fix button on a health factor should do.
sealed class HealthFix {
  const HealthFix();
}

class LogServiceFix extends HealthFix {
  final String serviceType;
  const LogServiceFix(this.serviceType);
}

class EditInsuranceFix extends HealthFix {
  const EditInsuranceFix();
}

class LogFuelFix extends HealthFix {
  const LogFuelFix();
}

/// The fix for a factor that isn't in good shape, or null when it is.
HealthFix? fixFor(HealthFactor f) {
  if (f.status == HealthStatus.good) return null;
  return switch (f.label) {
    'Insurance' => const EditInsuranceFix(),
    'Fuel Economy' => const LogFuelFix(),
    'Engine Oil' => LogServiceFix(f.serviceType ?? ServiceTypes.oilChange),
    'Chain' => LogServiceFix(f.serviceType ?? ServiceTypes.chainLube),
    'Air Filter' => LogServiceFix(f.serviceType ?? ServiceTypes.airFilter),
    'Brake Pads' => LogServiceFix(f.serviceType ?? ServiceTypes.brakePads),
    'Tyres' => LogServiceFix(f.serviceType ?? ServiceTypes.tyres),
    'Battery' => LogServiceFix(f.serviceType ?? ServiceTypes.battery),
    _ => null,
  };
}

/// Factors worst first, so the things to act on are at the top.
List<HealthFactor> sortedFactors(HealthScore score) =>
    [...score.factors]..sort((a, b) => a.ratio.compareTo(b.ratio));

/// Opens a breakdown of the health score: each factor's points, what it
/// means, and a one-tap fix. Returns the fix the rider picked, if any.
Future<HealthFix?> showHealthBreakdown(BuildContext context, HealthScore score) =>
    showModalBottomSheet<HealthFix>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheet) => _HealthBreakdown(score: score),
    );

class _HealthBreakdown extends StatelessWidget {
  final HealthScore score;
  const _HealthBreakdown({required this.score});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final track = isDark ? AppColors.trackDark : AppColors.track;

    Color statusColor(HealthStatus s) => switch (s) {
          HealthStatus.good => isDark ? AppColors.successDark : AppColors.success,
          HealthStatus.warning =>
            isDark ? AppColors.warningDark : AppColors.warning,
          HealthStatus.danger => isDark ? AppColors.dangerDark : AppColors.danger,
        };

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(l.healthBreakdownTitle.toUpperCase(),
                      style:
                          AppTextStyles.heading2.copyWith(color: textPrimary)),
                ),
                Text('${score.score}%',
                    style: AppTextStyles.metric.copyWith(
                        fontSize: 28,
                        color: HealthRing.gradeColor(score.grade,
                            isDark: isDark))),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(l.healthBreakdownBody,
                style: AppTextStyles.caption.copyWith(color: textSecondary)),
            const SizedBox(height: AppSpacing.lg),
            for (final f in sortedFactors(score)) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(l.healthFactorLabel(f.label).toUpperCase(),
                        style: AppTextStyles.label
                            .copyWith(color: textPrimary, fontSize: 14)),
                  ),
                  Text(
                    '${f.points.round()}/${f.maxPoints.round()}',
                    style: AppTextStyles.data.copyWith(
                        fontSize: 14, color: statusColor(f.status)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: f.ratio.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: track,
                  color: statusColor(f.status),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: Text(f.localizedMessage(l),
                        style: AppTextStyles.caption
                            .copyWith(color: textSecondary)),
                  ),
                  if (fixFor(f) case final fix?)
                    TextButton(
                      onPressed: () => Navigator.pop(context, fix),
                      child: Text(switch (fix) {
                        LogServiceFix() => l.healthFixLog,
                        EditInsuranceFix() => l.healthFixUpdate,
                        LogFuelFix() => l.dashboardLogFuel,
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}
