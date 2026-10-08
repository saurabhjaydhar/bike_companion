import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/local_data_provider.dart';

import '../../core/services/spending.dart';
import '../../data/models/expense.dart';
import '../../data/models/vehicle.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/ledger_repository.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../main.dart';

class ExpensesState {
  final Vehicle vehicle;
  final SpendingSummary summary;

  /// Full months before the current one, for suggesting a budget.
  final List<MonthTotal> recentMonths;

  const ExpensesState({
    required this.vehicle,
    required this.summary,
    required this.recentMonths,
  });

  SpendPeriod get period => summary.period;

  /// Budget for the period shown; null when not set.
  double? get budget => period.kind == PeriodKind.month
      ? vehicle.monthlyBudget
      : vehicle.yearlyBudget;
}

class ExpensesNotifier extends FamilyAsyncNotifier<ExpensesState, String> {
  SpendPeriod _period = SpendPeriod.current(PeriodKind.month, DateTime.now());

  @override
  Future<ExpensesState> build(String arg) {
    ref.watch(localDataEpochProvider);
    return _load();
  }

  Future<ExpensesState> _load() async {
    final now = DateTime.now();
    final ledger = getIt<LedgerRepository>();
    final vehicle = await getIt<VehicleRepository>().getVehicleById(arg);
    if (vehicle == null) throw StateError('Vehicle $arg not found');

    final range = ledgerRangeFor(_period);
    final summary = summarize(
      period: _period,
      entries: await ledger.entries(
          vehicleId: arg, from: range.from, to: range.to),
      readings: await ledger.odometerReadings(arg),
      now: now,
    );

    final recentMonths = <MonthTotal>[];
    for (var i = 3; i >= 1; i--) {
      final m = DateTime(now.year, now.month - i);
      recentMonths.add(MonthTotal(
        m,
        await ledger.total(
            vehicleId: arg, from: m, to: DateTime(m.year, m.month + 1)),
      ));
    }

    return ExpensesState(
      vehicle: vehicle,
      summary: summary,
      recentMonths: recentMonths,
    );
  }

  /// Reloads, keeping the current data on screen meanwhile.
  Future<void> reload() async {
    state = const AsyncLoading<ExpensesState>().copyWithPrevious(state);
    state = await AsyncValue.guard(_load);
  }

  Future<void> _show(SpendPeriod period) async {
    if (period.isFuture(DateTime.now())) return;
    _period = period;
    await reload();
  }

  Future<void> setKind(PeriodKind kind) =>
      _show(_period.switchTo(kind, DateTime.now()));

  Future<void> previous() => _show(_period.previous);
  Future<void> next() => _show(_period.next);

  /// Opens [month] in month view — from tapping a chart bar.
  Future<void> showMonth(DateTime month) =>
      _show(SpendPeriod.month(month.year, month.month));

  Future<void> addExpense(Expense expense) async {
    await getIt<ExpenseRepository>().insertExpense(expense);
    await reload();
  }

  Future<void> deleteExpense(String id) async {
    await getIt<ExpenseRepository>().deleteExpense(id);
    await reload();
  }
}

final expensesProvider =
    AsyncNotifierProvider.family<ExpensesNotifier, ExpensesState, String>(
  ExpensesNotifier.new,
);
