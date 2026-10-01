import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/expense.dart';
import '../../shared/widgets/empty_state.dart';
import 'expenses_provider.dart';

const _uuid = Uuid();

const _categoryColors = <String, Color>{
  'fuel': Color(0xFF1A56DB),
  'service': Color(0xFF0E9F6E),
  'parts': Color(0xFF8B5CF6),
  'insurance': Color(0xFFF59E0B),
  'parking': Color(0xFF06B6D4),
  'accessories': Color(0xFFEC4899),
  'fine': Color(0xFFEF4444),
  'other': Color(0xFF9CA3AF),
};

class ExpensesScreen extends ConsumerWidget {
  final String bikeId;
  const ExpensesScreen({super.key, required this.bikeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(expensesProvider(bikeId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final rupee = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          if (stateAsync.valueOrNull?.expenses.isNotEmpty ?? false)
            IconButton(
              icon: const Icon(Icons.ios_share_rounded),
              tooltip: 'Export CSV',
              onPressed: () => _exportCsv(stateAsync.value!),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpense(context, ref, bikeId),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (s) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(expensesProvider(bikeId));
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              // Month selector
              _MonthSelector(
                year: s.year,
                month: s.month,
                onPrev: () =>
                    ref.read(expensesProvider(bikeId).notifier).prevMonth(),
                onNext: () =>
                    ref.read(expensesProvider(bikeId).notifier).nextMonth(),
              ),

              // Summary card
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: _SummaryCard(
                  total: s.total,
                  prevTotal: s.prevMonthTotal,
                  breakdown: s.breakdown,
                  isDark: isDark,
                ),
              ),

              // 6-month bar chart
              if (s.sixMonthTrend.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: _BarChart(trend: s.sixMonthTrend, isDark: isDark),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Category breakdown
              if (s.breakdown.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg),
                  child: Text('By category',
                      style: AppTextStyles.heading3
                          .copyWith(color: textPrimary)),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...s.breakdown.entries
                    .toList()
                    .sorted((a, b) => b.value.compareTo(a.value))
                    .map((e) => _CategoryRow(
                          category: e.key,
                          amount: e.value,
                          total: s.total,
                          isDark: isDark,
                        )),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Transactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text('Transactions',
                    style: AppTextStyles.heading3
                        .copyWith(color: textPrimary)),
              ),
              const SizedBox(height: AppSpacing.sm),

              if (s.expenses.isEmpty)
                const EmptyState(
                  icon: Icons.receipt_long_rounded,
                  heading: 'No expenses',
                  body: 'Tap + to add your first expense this month.',
                )
              else
                ..._groupByDate(s.expenses).entries
                    .toList()
                    .sorted((a, b) => b.key.compareTo(a.key))
                    .expand((entry) => [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg, AppSpacing.md,
                                AppSpacing.lg, AppSpacing.sm),
                            child: Text(
                              DateFormat('d MMMM').format(entry.key),
                              style: AppTextStyles.captionMedium
                                  .copyWith(color: textSecondary),
                            ),
                          ),
                          ...entry.value.map((exp) => Dismissible(
                                key: Key(exp.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(
                                      right: AppSpacing.xl),
                                  color: AppColors.danger,
                                  child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.white),
                                ),
                                onDismissed: (_) => ref
                                    .read(expensesProvider(bikeId).notifier)
                                    .deleteExpense(exp.id),
                                child: ListTile(
                                  leading: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: (_categoryColors[exp.category] ??
                                              AppColors.textSecondary)
                                          .withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _categoryIcon(exp.category),
                                      size: 18,
                                      color: _categoryColors[exp.category] ??
                                          AppColors.textSecondary,
                                    ),
                                  ),
                                  title: Text(
                                    exp.note?.isNotEmpty == true
                                        ? exp.note!
                                        : ExpenseCategories.label(exp.category),
                                    style: AppTextStyles.bodyMedium
                                        .copyWith(color: textPrimary),
                                  ),
                                  subtitle: Text(
                                    ExpenseCategories.label(exp.category),
                                    style: AppTextStyles.caption
                                        .copyWith(color: textSecondary),
                                  ),
                                  trailing: Text(
                                    rupee.format(exp.amount),
                                    style: AppTextStyles.bodySemiBold
                                        .copyWith(color: textPrimary),
                                  ),
                                ),
                              )),
                        ]),
            ],
          ),
        ),
      ),
    );
  }

  Map<DateTime, List<Expense>> _groupByDate(List<Expense> expenses) {
    final map = <DateTime, List<Expense>>{};
    for (final e in expenses) {
      final key = DateTime(e.date.year, e.date.month, e.date.day);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'fuel': return Icons.local_gas_station_rounded;
      case 'service': return Icons.build_rounded;
      case 'parts': return Icons.hardware_rounded;
      case 'insurance': return Icons.verified_rounded;
      case 'parking': return Icons.local_parking_rounded;
      case 'accessories': return Icons.shopping_bag_rounded;
      case 'fine': return Icons.gavel_rounded;
      default: return Icons.receipt_rounded;
    }
  }

  void _exportCsv(ExpensesState s) {
    final monthName = DateFormat('MMMM yyyy').format(DateTime(s.year, s.month));
    final buf = StringBuffer();
    buf.writeln('Date,Category,Amount (₹),Note');
    for (final e in s.expenses) {
      final date = DateFormat('d MMM y').format(e.date);
      final note = (e.note ?? '').replaceAll(',', ' ');
      buf.writeln('$date,${e.category},${e.amount.toStringAsFixed(0)},$note');
    }
    Share.share(
      buf.toString(),
      subject: 'Expenses — $monthName',
    );
  }
}

extension _SortedList<T> on List<T> {
  List<T> sorted(int Function(T, T) compare) => [...this]..sort(compare);
}

// ---------------------------------------------------------------------------
// Month selector
// ---------------------------------------------------------------------------
class _MonthSelector extends StatelessWidget {
  final int year;
  final int month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.year,
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final isCurrentMonth = year == now.year && month == now.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: onPrev,
        ),
        Text(
          DateFormat('MMMM y').format(DateTime(year, month)),
          style: AppTextStyles.heading3.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right_rounded,
              color: isCurrentMonth
                  ? (isDark ? AppColors.borderDark : AppColors.border)
                  : null),
          onPressed: isCurrentMonth ? null : onNext,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Summary card with donut chart
// ---------------------------------------------------------------------------
class _SummaryCard extends StatelessWidget {
  final double total;
  final double? prevTotal;
  final Map<String, double> breakdown;
  final bool isDark;

  const _SummaryCard({
    required this.total,
    required this.prevTotal,
    required this.breakdown,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.surfaceDark : AppColors.surface;
    final border = isDark ? AppColors.borderDark : AppColors.border;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final rupee = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    final diff = prevTotal != null && prevTotal! > 0
        ? (total - prevTotal!) / prevTotal! * 100
        : null;
    final isLess = diff != null && diff < 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total spent',
                    style:
                        AppTextStyles.caption.copyWith(color: textSecondary)),
                const SizedBox(height: AppSpacing.xs),
                Text(rupee.format(total),
                    style: AppTextStyles.heading1
                        .copyWith(color: textPrimary)),
                if (diff != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(children: [
                    Icon(
                      isLess
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      size: 14,
                      color: isLess
                          ? (isDark
                              ? AppColors.successDark
                              : AppColors.success)
                          : (isDark
                              ? AppColors.dangerDark
                              : AppColors.danger),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${diff.abs().toStringAsFixed(0)}% vs last month',
                      style: AppTextStyles.captionMedium.copyWith(
                        color: isLess
                            ? (isDark
                                ? AppColors.successDark
                                : AppColors.success)
                            : (isDark
                                ? AppColors.dangerDark
                                : AppColors.danger),
                      ),
                    ),
                  ]),
                ],
              ],
            ),
          ),
          if (breakdown.isNotEmpty)
            SizedBox(
              width: 80,
              height: 80,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 24,
                  sections: breakdown.entries
                      .map((e) => PieChartSectionData(
                            color: _categoryColors[e.key] ??
                                AppColors.textSecondary,
                            value: e.value,
                            radius: 20,
                            showTitle: false,
                          ))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6-month bar chart
// ---------------------------------------------------------------------------
class _BarChart extends StatelessWidget {
  final List<dynamic> trend;
  final bool isDark;

  const _BarChart({required this.trend, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final maxVal =
        trend.fold(0.0, (m, s) => s.total > m ? s.total : m);

    return SizedBox(
      height: 140,
      child: BarChart(
        BarChartData(
          maxY: maxVal * 1.2,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final i = val.toInt();
                  if (i < 0 || i >= trend.length) return const SizedBox();
                  return Text(
                    DateFormat('MMM').format(
                        DateTime(trend[i].year, trend[i].month)),
                    style: AppTextStyles.label.copyWith(
                        color: textSecondary, fontSize: 10),
                  );
                },
              ),
            ),
          ),
          barGroups: trend.asMap().entries.map((e) {
            final isLast = e.key == trend.length - 1;
            final isMax = e.value.total == maxVal && maxVal > 0;
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.total,
                  color: isLast
                      ? AppColors.primary
                      : isMax
                          ? (isDark
                              ? AppColors.dangerDark
                              : AppColors.danger)
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.border),
                  width: 24,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category breakdown row
// ---------------------------------------------------------------------------
class _CategoryRow extends StatelessWidget {
  final String category;
  final double amount;
  final double total;
  final bool isDark;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.total,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final color =
        _categoryColors[category] ?? AppColors.textSecondary;
    final pct = total > 0 ? amount / total : 0.0;
    final rupee = NumberFormat.currency(
        locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(ExpenseCategories.label(category),
                    style:
                        AppTextStyles.bodyMedium.copyWith(color: textPrimary)),
              ),
              Text(rupee.format(amount),
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: textPrimary)),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 36,
                child: Text(
                  '${(pct * 100).round()}%',
                  style: AppTextStyles.caption.copyWith(color: textSecondary),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: pct,
              color: color,
              backgroundColor:
                  isDark ? AppColors.borderDark : AppColors.border,
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Add expense bottom sheet
// ---------------------------------------------------------------------------
void _showAddExpense(
    BuildContext context, WidgetRef ref, String bikeId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large)),
    ),
    builder: (_) =>
        _AddExpenseSheet(bikeId: bikeId, ref: ref),
  );
}

class _AddExpenseSheet extends StatefulWidget {
  final String bikeId;
  final WidgetRef ref;

  const _AddExpenseSheet(
      {required this.bikeId, required this.ref});

  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  String _category = ExpenseCategories.fuel;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) return;
    setState(() => _saving = true);
    try {
      final expense = Expense(
        id: _uuid.v4(),
        bikeId: widget.bikeId,
        date: _date,
        category: _category,
        amount: amount,
        note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      );
      await widget.ref
          .read(expensesProvider(widget.bikeId).notifier)
          .addExpense(expense);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xl,
          MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Add expense', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),

          // Category grid
          Text('Category',
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: ExpenseCategories.all.map((cat) {
              final isSelected = _category == cat;
              final color =
                  _categoryColors[cat] ?? AppColors.textSecondary;
              return GestureDetector(
                onTap: () => setState(() => _category = cat),
                child: AnimatedContainer(
                  duration: AppDuration.fast,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.15)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? color
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.border),
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    ExpenseCategories.label(cat),
                    style: AppTextStyles.captionMedium.copyWith(
                      color: isSelected ? color : textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Amount (₹)',
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _amountCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: const InputDecoration(
                hintText: '0', prefixText: '₹ '),
          ),
          const SizedBox(height: AppSpacing.lg),

          Text('Note (optional)',
              style: AppTextStyles.label.copyWith(color: textSecondary)),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _noteCtrl,
            decoration: const InputDecoration(
                hintText: 'Merchant, description...'),
          ),
          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Save expense'),
            ),
          ),
        ],
      ),
    );
  }
}
