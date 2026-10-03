import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/analytics.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/vehicle.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import '../../shared/widgets/primary_button.dart';
import '../dashboard/dashboard_provider.dart';
import '../garage/garage_provider.dart';
import 'expense_style.dart';
import 'expenses_provider.dart';

/// Set or change a vehicle's spending budget. [suggestion] (from recent
/// spending) is offered as a one-tap starting point.
Future<void> showBudgetSheet(
  BuildContext context,
  WidgetRef ref, {
  required Vehicle vehicle,
  double? suggestion,
}) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
  ),
  builder: (_) =>
      _BudgetSheet(vehicle: vehicle, suggestion: suggestion, ref: ref),
);

class _BudgetSheet extends StatefulWidget {
  final Vehicle vehicle;
  final double? suggestion;
  final WidgetRef ref;

  const _BudgetSheet({
    required this.vehicle,
    required this.suggestion,
    required this.ref,
  });

  @override
  State<_BudgetSheet> createState() => _BudgetSheetState();
}

class _BudgetSheetState extends State<_BudgetSheet> {
  static const _step = 500.0;

  late double _monthly;
  late final TextEditingController _yearlyCtrl;

  /// The yearly budget follows the monthly one until edited by hand.
  late bool _yearlyFollows;

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _monthly = v.monthlyBudget ?? widget.suggestion ?? 3000;
    _yearlyFollows = v.yearlyBudget == null ||
        v.yearlyBudget == (v.monthlyBudget ?? 0) * 12;
    _yearlyCtrl = TextEditingController(
        text: (v.yearlyBudget ?? _monthly * 12).toStringAsFixed(0));
  }

  @override
  void dispose() {
    _yearlyCtrl.dispose();
    super.dispose();
  }

  double get _max => math.max(
        20000,
        (math.max(_monthly, widget.suggestion ?? 0) * 3 / _step).ceil() * _step,
      );

  void _setMonthly(double value) {
    setState(() {
      _monthly = value;
      if (_yearlyFollows) _yearlyCtrl.text = (value * 12).toStringAsFixed(0);
    });
  }

  Future<void> _save({bool remove = false}) async {
    final yearly = double.tryParse(_yearlyCtrl.text);
    final updated = remove
        ? widget.vehicle.withBudgets()
        : widget.vehicle.withBudgets(
            monthly: _monthly > 0 ? _monthly : null,
            yearly: yearly != null && yearly > 0 ? yearly : null,
          );
    await getIt<VehicleRepository>().updateVehicle(updated);
    if (!remove) {
      Analytics.budgetSet(
        monthly: updated.monthlyBudget != null,
        yearly: updated.yearlyBudget != null,
      );
    }
    HapticFeedback.lightImpact();
    final ref = widget.ref;
    ref.invalidate(expensesProvider(widget.vehicle.id));
    ref.invalidate(dashboardProvider(widget.vehicle.id));
    ref.invalidate(garageProvider);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;
    final suggestion = widget.suggestion;
    final hasBudget = widget.vehicle.monthlyBudget != null ||
        widget.vehicle.yearlyBudget != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.budgetSheetTitle,
              style: AppTextStyles.heading2.copyWith(color: textPrimary)),
          const SizedBox(height: AppSpacing.lg),
          Text(l.budgetMonthly,
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          Text(rupees(_monthly),
              style:
                  AppTextStyles.metric.copyWith(color: textPrimary, fontSize: 32)),
          Slider(
            value: _monthly.clamp(0, _max),
            max: _max,
            divisions: (_max / _step).round(),
            label: rupees(_monthly),
            activeColor: AppColors.primary,
            onChanged: (v) {
              if (v != _monthly) HapticFeedback.selectionClick();
              _setMonthly(v);
            },
          ),
          if (suggestion != null)
            ActionChip(
              avatar: const Icon(Icons.auto_awesome_rounded,
                  size: 18, color: AppColors.accent),
              label: Text(l.budgetSuggested(rupees(suggestion))),
              onPressed: () => _setMonthly(suggestion),
            ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _yearlyCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => _yearlyFollows = false,
            decoration: InputDecoration(
              labelText: l.budgetYearly,
              prefixText: '₹ ',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: l.budgetSave,
            icon: Icons.savings_rounded,
            onPressed: _save,
          ),
          if (hasBudget)
            Center(
              child: TextButton(
                onPressed: () => _save(remove: true),
                child: Text(l.budgetRemove,
                    style: const TextStyle(color: AppColors.danger)),
              ),
            ),
        ],
      ),
    );
  }
}
