import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/spending.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/widgets/hud_panel.dart';
import '../../expenses/expense_style.dart';

/// This month's spending, with a ring filling up against the monthly budget
/// (green → amber at 80 % → red at 100 %).
class SpendingCard extends StatelessWidget {
  final double spent;
  final double? budget;

  /// Opens the spending screen.
  final VoidCallback onOpen;

  /// Opens the budget sheet.
  final VoidCallback onSetBudget;

  const SpendingCard({
    super.key,
    required this.spent,
    required this.budget,
    required this.onOpen,
    required this.onSetBudget,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final track = isDark ? AppColors.borderDark : AppColors.border;
    final progress = budget == null ? null : BudgetProgress(spent, budget!);
    final colour = switch (progress?.level) {
      BudgetLevel.near => AppColors.warning,
      BudgetLevel.over => AppColors.danger,
      _ => AppColors.success,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: HudPanel(
        onTap: onOpen,
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                        begin: 0, end: (progress?.ratio ?? 0).clamp(0, 1)),
                    duration: AppDuration.slow,
                    builder: (_, value, _) => CircularProgressIndicator(
                      value: progress == null ? 0 : value,
                      strokeWidth: 7,
                      strokeCap: StrokeCap.round,
                      color: colour,
                      backgroundColor: track,
                    ),
                  ),
                  progress == null
                      ? Icon(Icons.savings_outlined, color: textSecondary)
                      : Text('${(progress.ratio * 100).round()}%',
                          style: AppTextStyles.captionMedium.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.dashboardThisMonth,
                      style:
                          AppTextStyles.label.copyWith(color: textSecondary)),
                  Text(rupees(spent),
                      style: AppTextStyles.metric
                          .copyWith(color: textPrimary, fontSize: 24)),
                  if (progress != null)
                    Text(
                      progress.remaining >= 0
                          ? l.budgetLeftOf(rupees(progress.remaining),
                              rupees(budget!))
                          : l.budgetOver(rupees(-progress.remaining)),
                      style: AppTextStyles.caption.copyWith(color: colour),
                    ),
                ],
              ),
            ),
            if (progress == null)
              TextButton(onPressed: onSetBudget, child: Text(l.budgetSet))
            else
              Icon(Icons.chevron_right_rounded, color: textSecondary),
          ],
        ),
      ),
    );
  }
}
