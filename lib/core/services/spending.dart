import 'dart:math' as math;

import '../../data/models/ledger_entry.dart';
import '../constants/app_constants.dart';

enum PeriodKind { month, year }

/// A calendar month or year to total spending over.
class SpendPeriod {
  final PeriodKind kind;
  final int year;

  /// 1–12; 1 for a year period.
  final int month;

  const SpendPeriod.month(this.year, this.month) : kind = PeriodKind.month;
  const SpendPeriod.year(this.year) : kind = PeriodKind.year, month = 1;

  factory SpendPeriod.current(PeriodKind kind, DateTime now) =>
      kind == PeriodKind.month
          ? SpendPeriod.month(now.year, now.month)
          : SpendPeriod.year(now.year);

  DateTime get start =>
      kind == PeriodKind.month ? DateTime(year, month) : DateTime(year);

  DateTime get end =>
      kind == PeriodKind.month ? DateTime(year, month + 1) : DateTime(year + 1);

  SpendPeriod get previous => _shift(-1);
  SpendPeriod get next => _shift(1);

  SpendPeriod _shift(int by) {
    if (kind == PeriodKind.year) return SpendPeriod.year(year + by);
    final d = DateTime(year, month + by);
    return SpendPeriod.month(d.year, d.month);
  }

  /// Whether [now] falls in this period.
  bool contains(DateTime now) => !now.isBefore(start) && now.isBefore(end);

  bool isFuture(DateTime now) => start.isAfter(now);

  /// This period seen as [other]: a month becomes its year; a year becomes
  /// its current month if it's this year, else its December.
  SpendPeriod switchTo(PeriodKind other, DateTime now) {
    if (other == kind) return this;
    if (other == PeriodKind.year) return SpendPeriod.year(year);
    return year == now.year
        ? SpendPeriod.month(year, now.month)
        : SpendPeriod.month(year, 12);
  }

  /// Months the chart shows: the year's 12, or the 6 ending with this one.
  List<DateTime> get chartMonths => kind == PeriodKind.year
      ? [for (var m = 1; m <= 12; m++) DateTime(year, m)]
      : [for (var i = 5; i >= 0; i--) DateTime(year, month - i)];

  /// Stable key, e.g. "m2026-03" or "y2026".
  String get key => kind == PeriodKind.year
      ? 'y$year'
      : 'm$year-${month.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) =>
      other is SpendPeriod &&
      other.kind == kind &&
      other.year == year &&
      other.month == month;

  @override
  int get hashCode => Object.hash(kind, year, month);
}

class MonthTotal {
  final DateTime month;
  final double total;

  const MonthTotal(this.month, this.total);
}

/// Everything the spending screen shows for one period.
class SpendingSummary {
  final SpendPeriod period;
  final List<LedgerEntry> entries;
  final double total;
  final double previousTotal;
  final Map<String, double> byCategory;
  final List<MonthTotal> chart;

  /// Average per month, from the first month with spending in the chart up
  /// to the current month.
  final double averageMonthly;

  /// Kilometres driven in the period, from odometer readings.
  final int? kmDriven;

  const SpendingSummary({
    required this.period,
    required this.entries,
    required this.total,
    required this.previousTotal,
    required this.byCategory,
    required this.chart,
    required this.averageMonthly,
    required this.kmDriven,
  });

  /// Change against the previous period in percent; null without spending
  /// to compare with.
  double? get changePercent =>
      previousTotal > 0 ? (total - previousTotal) / previousTotal * 100 : null;

  double get fuelTotal => byCategory[ExpenseCategories.fuel] ?? 0;

  double? get costPerKm =>
      (kmDriven ?? 0) > 0 && total > 0 ? total / kmDriven! : null;

  double? get fuelCostPerKm =>
      (kmDriven ?? 0) > 0 && fuelTotal > 0 ? fuelTotal / kmDriven! : null;
}

/// Summarises [entries] for [period]. [entries] must cover the chart months
/// and the previous period (see [ledgerRangeFor]).
SpendingSummary summarize({
  required SpendPeriod period,
  required List<LedgerEntry> entries,
  required List<OdometerReading> readings,
  required DateTime now,
}) {
  bool inRange(LedgerEntry e, DateTime from, DateTime to) =>
      !e.date.isBefore(from) && e.date.isBefore(to);
  double sum(Iterable<LedgerEntry> es) =>
      es.fold(0.0, (total, e) => total + e.amount);

  final current = [
    for (final e in entries)
      if (inRange(e, period.start, period.end)) e,
  ]..sort((a, b) => b.date.compareTo(a.date));
  final previous = period.previous;

  final byCategory = <String, double>{};
  for (final e in current) {
    byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount;
  }

  final chart = [
    for (final m in period.chartMonths)
      MonthTotal(
        m,
        sum(entries.where(
            (e) => inRange(e, m, DateTime(m.year, m.month + 1)))),
      ),
  ];

  // Average over months from the first with spending up to this month.
  final counted = chart
      .skipWhile((m) => m.total == 0)
      .where((m) => !m.month.isAfter(now))
      .toList();
  final average = counted.isEmpty
      ? 0.0
      : counted.fold(0.0, (t, m) => t + m.total) / counted.length;

  return SpendingSummary(
    period: period,
    entries: current,
    total: sum(current),
    previousTotal:
        sum(entries.where((e) => inRange(e, previous.start, previous.end))),
    byCategory: byCategory,
    chart: chart,
    averageMonthly: average,
    kmDriven: kmDriven(readings, period.start, period.end),
  );
}

/// Date range of ledger entries [summarize] needs for [period].
({DateTime from, DateTime to}) ledgerRangeFor(SpendPeriod period) {
  final chartStart = period.chartMonths.first;
  final previousStart = period.previous.start;
  return (
    from: chartStart.isBefore(previousStart) ? chartStart : previousStart,
    to: period.end,
  );
}

/// Kilometres driven in [from, to): the last reading in the range minus the
/// last one before it (or the first one in it). Null when unknown.
int? kmDriven(List<OdometerReading> readings, DateTime from, DateTime to) {
  final sorted = [...readings]..sort((a, b) => a.date.compareTo(b.date));
  final before = sorted.where((r) => r.date.isBefore(from));
  final inside = sorted.where((r) => !r.date.isBefore(from) && r.date.isBefore(to));
  if (inside.isEmpty) return null;
  final startKm = before.isNotEmpty ? before.last.km : inside.first.km;
  final driven = inside.map((r) => r.km).reduce(math.max) - startKm;
  return driven > 0 ? driven : null;
}

// ---------------------------------------------------------------------------
// Budgets
// ---------------------------------------------------------------------------

enum BudgetLevel { ok, near, over }

/// Share of the budget at which the user is warned.
const budgetWarnAt = 0.8;

class BudgetProgress {
  final double spent;
  final double budget;

  const BudgetProgress(this.spent, this.budget);

  double get ratio => budget > 0 ? spent / budget : 0;
  double get remaining => budget - spent;

  BudgetLevel get level => ratio >= 1
      ? BudgetLevel.over
      : ratio >= budgetWarnAt
          ? BudgetLevel.near
          : BudgetLevel.ok;
}

/// Alert thresholds (80 and 100 percent) [spent] has reached.
List<int> budgetThresholdsReached(double spent, double? budget) => [
  if (budget != null && budget > 0)
    for (final pct in const [80, 100])
      if (spent >= budget * pct / 100) pct,
];

/// Suggested monthly budget: the average of the last full months with
/// spending (up to 3), rounded up to the next 500. Null without history.
double? suggestMonthlyBudget(List<MonthTotal> fullMonths) {
  final recent = fullMonths.where((m) => m.total > 0).toList();
  final last = recent.length > 3 ? recent.sublist(recent.length - 3) : recent;
  if (last.isEmpty) return null;
  final average = last.fold(0.0, (t, m) => t + m.total) / last.length;
  return (average / 500).ceil() * 500.0;
}
