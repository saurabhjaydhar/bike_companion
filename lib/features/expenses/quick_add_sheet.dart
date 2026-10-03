import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/expense.dart';
import '../../data/repositories/expense_repository.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import '../../shared/widgets/primary_button.dart';
import '../dashboard/dashboard_provider.dart';
import '../garage/garage_provider.dart';
import 'expense_style.dart';
import 'expenses_provider.dart';

/// Quick add: pick a category, type the amount, save. Date and vehicle are
/// prefilled.
Future<void> showQuickAddExpense(
  BuildContext context,
  WidgetRef ref, {
  required String vehicleId,
}) => showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
  ),
  builder: (_) => _QuickAddSheet(vehicleId: vehicleId, ref: ref),
);

class _QuickAddSheet extends StatefulWidget {
  final String vehicleId;
  final WidgetRef ref;

  const _QuickAddSheet({required this.vehicleId, required this.ref});

  @override
  State<_QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<_QuickAddSheet> {
  String _category = ExpenseCategories.fuel;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  double? get _amount => double.tryParse(_amountCtrl.text.replaceAll(',', ''));

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final amount = _amount;
    if (amount == null || amount <= 0) return;
    setState(() => _saving = true);
    try {
      await getIt<ExpenseRepository>().insertExpense(Expense(
        id: const Uuid().v4(),
        vehicleId: widget.vehicleId,
        date: _date,
        category: _category,
        amount: amount,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      ));
      HapticFeedback.lightImpact();
      final ref = widget.ref;
      ref.invalidate(expensesProvider(widget.vehicleId));
      ref.invalidate(dashboardProvider(widget.vehicleId));
      ref.invalidate(garageProvider);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final l = context.l10n;
    final now = DateTime.now();
    final isToday = DateUtils.isSameDay(_date, now);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l.expensesAddTitle,
                style: AppTextStyles.heading2.copyWith(color: textPrimary)),
            const SizedBox(height: AppSpacing.lg),

            // Category tiles
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.95,
              children: [
                for (final cat in ExpenseCategories.all)
                  _CategoryTile(
                    label: l.expenseCategoryLabel(cat),
                    icon: categoryIcon(cat),
                    colour: categoryColour(cat),
                    selected: _category == cat,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _category = cat);
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Amount — focused, number pad
            TextField(
              controller: _amountCtrl,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _save(),
              style: AppTextStyles.metric
                  .copyWith(color: textPrimary, fontSize: 32),
              decoration: InputDecoration(
                labelText: l.expensesAmount,
                prefixText: '₹ ',
                hintText: '0',
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Date + note
            Row(
              children: [
                ActionChip(
                  avatar: const Icon(Icons.event_rounded, size: 18),
                  label: Text(isToday
                      ? l.commonToday
                      : DateFormat.yMMMd(l.localeName).format(_date)),
                  onPressed: _pickDate,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(
                      hintText: l.expensesNoteOptional,
                      isDense: true,
                    ),
                    style: AppTextStyles.body.copyWith(color: textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            PrimaryButton(
              label: _amount != null && _amount! > 0
                  ? '${l.expensesSave} · ${rupees(_amount!)}'
                  : l.expensesSave,
              icon: Icons.check_rounded,
              isLoading: _saving,
              onPressed: _amount != null && _amount! > 0 ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color colour;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.colour,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: AnimatedContainer(
          duration: AppDuration.fast,
          decoration: BoxDecoration(
            color: selected ? colour.withValues(alpha: 0.16) : null,
            border: Border.all(
                color: selected ? colour : border, width: selected ? 1.5 : 1),
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colour, size: 24),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? colour : textSecondary,
                    fontWeight: selected ? FontWeight.w700 : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
