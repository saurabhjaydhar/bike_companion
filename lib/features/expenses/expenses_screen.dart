import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/spending.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/expense.dart';
import '../../data/models/ledger_entry.dart';
import '../../l10n/l10n.dart';
import '../../shared/widgets/first_time_tips.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/hud_panel.dart';
import 'budget_sheet.dart';
import 'expense_style.dart';
import 'expenses_provider.dart';
import 'quick_add_sheet.dart';
import '../../shared/widgets/clay_icon.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  const ExpensesScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  /// The add button hides while scrolling down so it never covers amounts,
  /// and comes back on scroll up.
  bool _fabVisible = true;

  bool _onScroll(UserScrollNotification n) {
    final visible = switch (n.direction) {
      ScrollDirection.reverse => false,
      ScrollDirection.forward => true,
      ScrollDirection.idle => _fabVisible,
    };
    if (visible != _fabVisible) setState(() => _fabVisible = visible);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final vehicleId = widget.vehicleId;
    final stateAsync = ref.watch(expensesProvider(vehicleId));
    final notifier = ref.read(expensesProvider(vehicleId).notifier);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.expensesTitle),
        actions: [
          if (stateAsync.valueOrNull?.summary.entries.isNotEmpty ?? false)
            IconButton(
              icon: const Icon(Icons.ios_share_rounded),
              tooltip: l.expensesExportCsv,
              onPressed: () => _exportCsv(l, stateAsync.value!),
            ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: _fabVisible ? 1 : 0,
        duration: AppDuration.fast,
        child: FloatingActionButton(
          onPressed: () =>
              showQuickAddExpense(context, ref, vehicleId: vehicleId),
          backgroundColor: AppColors.primary,
          tooltip: l.expensesAddTitle,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: _onScroll,
        child: stateAsync.when(
          skipLoadingOnReload: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (s) => GestureDetector(
            // Swipe left/right to move between months or years.
            onHorizontalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v > 300) notifier.previous();
              if (v < -300) notifier.next();
            },
            child: RefreshIndicator(
              onRefresh: notifier.reload,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  TipCard(
                    id: Tips.expenses,
                    text: l.tipExpenses,
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                  ),
                  Center(
                    child: SegmentedButton<PeriodKind>(
                      segments: [
                        ButtonSegment(
                            value: PeriodKind.month,
                            label: Text(l.expensesModeMonth)),
                        ButtonSegment(
                            value: PeriodKind.year,
                            label: Text(l.expensesModeYear)),
                      ],
                      selected: {s.period.kind},
                      showSelectedIcon: false,
                      onSelectionChanged: (k) => notifier.setKind(k.single),
                    ),
                  ),
                  _PeriodSelector(
                    period: s.period,
                    onPrev: notifier.previous,
                    onNext: notifier.next,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    child: _Headline(summary: s.summary),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: _BudgetBar(
                      state: s,
                      onEdit: () => showBudgetSheet(
                        context,
                        ref,
                        vehicle: s.vehicle,
                        suggestion: suggestMonthlyBudget(s.recentMonths),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: _StatsRow(summary: s.summary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (s.summary.chart.any((m) => m.total > 0))
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: _BarChart(
                        summary: s.summary,
                        onTapMonth: notifier.showMonth,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  if (s.summary.byCategory.isNotEmpty) ...[
                    _SectionTitle(l.expensesByCategory),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: HudPanel(
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Column(
                          children: [
                            for (final e in (s.summary.byCategory.entries
                                    .toList()
                                  ..sort((a, b) => b.value.compareTo(a.value))))
                              _CategoryRow(
                                category: e.key,
                                amount: e.value,
                                total: s.summary.total,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  _SectionTitle(l.expensesTransactions),
                  if (s.summary.entries.isEmpty)
                    EmptyState(
                      icon: Icons.receipt_long_rounded,
                      heading: l.expensesEmptyTitle,
                      body: l.expensesEmptyBody,
                    )
                  else
                    ..._entryTiles(context, ref, s.summary.entries),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _entryTiles(
    BuildContext context,
    WidgetRef ref,
    List<LedgerEntry> entries,
  ) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    // One card per day, under a date heading.
    final days = <(DateTime, List<Widget>)>[];
    for (final e in entries) {
      final d = DateUtils.dateOnly(e.date);
      if (days.isEmpty || days.last.$1 != d) days.add((d, []));
      final tiles = days.last.$2;
      final tile = _EntryTile(entry: e);
      if (e.source != LedgerSource.expense) {
        tiles.add(tile);
        continue;
      }
      tiles.add(Dismissible(
        key: ValueKey(e.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.xl),
          color: AppColors.danger,
          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
        ),
        onDismissed: (_) => _deleteWithUndo(context, ref, e),
        child: tile,
      ));
    }
    return [
      for (final (d, tiles) in days) ...[
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          child: Text(DateFormat('d MMMM', l.localeName).format(d),
              style: AppTextStyles.captionMedium.copyWith(color: textSecondary)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: HudGroup(dividerIndent: 68, children: tiles),
        ),
      ],
    ];
  }

  Future<void> _deleteWithUndo(
    BuildContext context,
    WidgetRef ref,
    LedgerEntry e,
  ) async {
    final notifier = ref.read(expensesProvider(widget.vehicleId).notifier);
    final messenger = ScaffoldMessenger.of(context);
    final l = context.l10n;
    await notifier.deleteExpense(e.id);
    messenger.showSnackBar(SnackBar(
      content: Text(l.expensesDeleted),
      action: SnackBarAction(
        label: l.commonUndo,
        onPressed: () => notifier.addExpense(Expense(
          id: e.id,
          vehicleId: e.vehicleId,
          date: e.date,
          category: e.category,
          amount: e.amount,
          note: e.note,
        )),
      ),
    ));
  }

  void _exportCsv(AppLocalizations l, ExpensesState s) {
    final period = s.period;
    final label = period.kind == PeriodKind.year
        ? '${period.year}'
        : DateFormat('MMMM yyyy', l.localeName).format(period.start);
    final buf = StringBuffer()..writeln(l.expensesCsvHeader);
    for (final e in s.summary.entries.reversed) {
      final date = DateFormat('d MMM y', l.localeName).format(e.date);
      final category = l.expenseCategoryLabel(e.category).replaceAll(',', ' ');
      final note = _noteFor(l, e).replaceAll(',', ' ');
      buf.writeln('$date,$category,${e.amount.toStringAsFixed(0)},$note');
    }
    Share.share(buf.toString(), subject: l.expensesCsvSubject(label));
  }
}

/// What a ledger entry is about: the expense note, the fuel station, or the
/// service done.
String _noteFor(AppLocalizations l, LedgerEntry e) => switch (e.source) {
  LedgerSource.expense => e.note ?? '',
  LedgerSource.fuel => e.note ?? l.expensesFromFuelLog,
  LedgerSource.service => l.serviceTypeLabel(e.note ?? ''),
};

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
      child: Text(text,
          style: AppTextStyles.heading3.copyWith(
              color:
                  isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)),
    );
  }
}

// ---------------------------------------------------------------------------
// Period selector
// ---------------------------------------------------------------------------
class _PeriodSelector extends StatelessWidget {
  final SpendPeriod period;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _PeriodSelector({
    required this.period,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = context.l10n;
    final canGoNext = !period.next.isFuture(DateTime.now());
    final label = period.kind == PeriodKind.year
        ? '${period.year}'
        : DateFormat('MMMM y', l.localeName).format(period.start);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: onPrev,
        ),
        Text(label,
            style: AppTextStyles.heading3.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary)),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: canGoNext ? onNext : null,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Headline: total, change vs previous period, category donut
// ---------------------------------------------------------------------------
class _Headline extends StatelessWidget {
  final SpendingSummary summary;
  const _Headline({required this.summary});

  @override
  Widget build(BuildContext context) {
    // Carbon panel: always drawn light-on-dark, whatever the page theme.
    final textPrimary = AppColors.textPrimaryDark;
    final textSecondary = AppColors.textSecondaryDark;
    final l = context.l10n;
    final change = summary.changePercent;
    final down = change != null && change < 0;
    final changeColour = down
        ? (AppColors.successDark)
        : (AppColors.dangerDark);
    final pct = change?.abs().toStringAsFixed(0);

    return HudPanel(
      carbon: true,
      // Leave the livery stripes their band on the end edge.
      padding: const EdgeInsetsDirectional.fromSTEB(AppSpacing.xl,
          AppSpacing.xl, AppSpacing.xl + HudPanel.stripeBand, AppSpacing.xl),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.expensesTotalSpent,
                    style: AppTextStyles.label.copyWith(color: textSecondary)),
                const SizedBox(height: AppSpacing.xs),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(rupees(summary.total),
                      style: AppTextStyles.metric
                          .copyWith(color: textPrimary, fontSize: 32)),
                ),
                if (pct != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Row(children: [
                    Icon(
                      down
                          ? Icons.trending_down_rounded
                          : Icons.trending_up_rounded,
                      size: 14,
                      color: changeColour,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        summary.period.kind == PeriodKind.year
                            ? l.expensesVsLastYear(pct)
                            : l.expensesVsLastMonth(pct),
                        style: AppTextStyles.captionMedium
                            .copyWith(color: changeColour),
                      ),
                    ),
                  ]),
                ],
              ],
            ),
          ),
          if (summary.byCategory.isNotEmpty)
            SizedBox(
              width: 80,
              height: 80,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 24,
                  sections: [
                    for (final e in summary.byCategory.entries)
                      PieChartSectionData(
                        color: categoryColour(e.key),
                        value: e.value,
                        radius: 20,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Budget bar
// ---------------------------------------------------------------------------
class _BudgetBar extends StatelessWidget {
  final ExpensesState state;
  final VoidCallback onEdit;

  const _BudgetBar({required this.state, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;
    final budget = state.budget;

    if (budget == null) {
      return HudPanel(
        onTap: onEdit,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.savings_outlined, color: AppColors.accentFor(isDark)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(l.budgetSetPrompt,
                  style: AppTextStyles.caption.copyWith(color: textSecondary)),
            ),
            TextButton(onPressed: onEdit, child: Text(l.budgetSet)),
          ],
        ),
      );
    }

    final progress = BudgetProgress(state.summary.total, budget);
    final colour = switch (progress.level) {
      BudgetLevel.ok => AppColors.success,
      BudgetLevel.near => AppColors.warning,
      BudgetLevel.over => AppColors.danger,
    };
    return HudPanel(
      onTap: onEdit,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.budgetOf(rupees(progress.spent), rupees(budget)),
                  style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
                ),
              ),
              Text(
                progress.remaining >= 0
                    ? l.budgetLeft(rupees(progress.remaining))
                    : l.budgetOver(rupees(-progress.remaining)),
                style: AppTextStyles.captionMedium.copyWith(color: colour),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.edit_outlined, size: 16, color: textSecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress.ratio.clamp(0, 1)),
              duration: AppDuration.slow,
              builder: (_, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                color: colour,
                backgroundColor:
                    isDark ? AppColors.trackDark : AppColors.track,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Average / cost per km / fuel per km
// ---------------------------------------------------------------------------
class _StatsRow extends StatelessWidget {
  final SpendingSummary summary;
  const _StatsRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    String perKm(double? v) => v == null ? '—' : '₹${v.toStringAsFixed(2)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _MiniStat(
                    label: l.expensesAvgMonthly,
                    value: rupees(summary.averageMonthly)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
                    label: l.expensesCostPerKm,
                    value: perKm(summary.costPerKm)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MiniStat(
                    label: l.expensesFuelPerKm,
                    value: perKm(summary.fuelCostPerKm)),
              ),
            ],
          ),
        ),
        if (summary.costPerKm == null && summary.total > 0)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(l.expensesNeedOdometer,
                style: AppTextStyles.caption.copyWith(color: textSecondary)),
          ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return HudPanel(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(value,
                style: AppTextStyles.bodySemiBold.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Monthly bars — tap one to open that month
// ---------------------------------------------------------------------------
class _BarChart extends StatelessWidget {
  final SpendingSummary summary;
  final void Function(DateTime month) onTapMonth;

  const _BarChart({required this.summary, required this.onTapMonth});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;
    final chart = summary.chart;
    final maxVal = chart.fold(0.0, (m, s) => s.total > m ? s.total : m);
    final period = summary.period;
    final yearView = period.kind == PeriodKind.year;
    bool selected(DateTime m) =>
        !yearView && m.year == period.year && m.month == period.month;

    return HudPanel(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: SizedBox(
      height: 150,
      child: BarChart(
        BarChartData(
          maxY: maxVal * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                rupees(rod.toY),
                AppTextStyles.captionMedium.copyWith(color: Colors.white),
              ),
            ),
            touchCallback: (event, response) {
              final index = response?.spot?.touchedBarGroupIndex;
              if (event is FlTapUpEvent && index != null) {
                HapticFeedback.selectionClick();
                onTapMonth(chart[index].month);
              }
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final i = val.toInt();
                  if (i < 0 || i >= chart.length) return const SizedBox();
                  final format = yearView ? 'MMMMM' : 'MMM';
                  return Text(
                    DateFormat(format, l.localeName).format(chart[i].month),
                    style: AppTextStyles.label
                        .copyWith(color: textSecondary, fontSize: 10),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (final (i, m) in chart.indexed)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: m.total,
                    color: selected(m.month) || yearView
                        ? AppColors.primary
                        : AppColors.primary
                            .withValues(alpha: isDark ? 0.25 : 0.22),
                    width: yearView ? 14 : 24,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ],
              ),
          ],
        ),
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

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final colour = categoryColour(category);
    final pct = total > 0 ? amount / total : 0.0;

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
                      BoxDecoration(color: colour, shape: BoxShape.circle)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(context.l10n.expenseCategoryLabel(category),
                    style:
                        AppTextStyles.bodyMedium.copyWith(color: textPrimary)),
              ),
              Text(rupees(amount),
                  style: AppTextStyles.bodyMedium.copyWith(color: textPrimary)),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 36,
                child: Text('${(pct * 100).round()}%',
                    style: AppTextStyles.caption.copyWith(color: textSecondary),
                    textAlign: TextAlign.end),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: pct,
              color: colour,
              backgroundColor:
                  isDark ? AppColors.trackDark : AppColors.track,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// One ledger entry
// ---------------------------------------------------------------------------
class _EntryTile extends StatelessWidget {
  final LedgerEntry entry;
  const _EntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final l = context.l10n;
    final colour = categoryColour(entry.category);
    final note = _noteFor(l, entry);
    final source = switch (entry.source) {
      LedgerSource.fuel => l.expensesFromFuelLog,
      LedgerSource.service => l.expensesFromService,
      LedgerSource.expense => null,
    };

    return ListTile(
      onTap: switch (entry.source) {
        LedgerSource.fuel => () => context.go(
            '/garage/dashboard/${entry.vehicleId}/fuel/history'),
        LedgerSource.service => () => context.go('/service/${entry.vehicleId}'),
        LedgerSource.expense => null,
      },
      leading: ClayIcon(icon: categoryIcon(entry.category), color: colour, size: 38),
      title: Text(
        note.isNotEmpty ? note : l.expenseCategoryLabel(entry.category),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodyMedium.copyWith(color: textPrimary),
      ),
      subtitle: Row(
        children: [
          Text(l.expenseCategoryLabel(entry.category),
              style: AppTextStyles.caption.copyWith(color: textSecondary)),
          if (source != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: colour.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(source,
                  style: AppTextStyles.caption
                      .copyWith(color: colour, fontSize: 10)),
            ),
          ],
        ],
      ),
      trailing: Text(rupees(entry.amount),
          style: AppTextStyles.bodySemiBold.copyWith(color: textPrimary)),
    );
  }
}
