import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/expense.dart';
import '../../data/repositories/expense_repository.dart';
import '../../main.dart';

class ExpensesState {
  final int year;
  final int month;
  final List<Expense> expenses;
  final Map<String, double> breakdown;
  final List<MonthSummary> sixMonthTrend;
  final double total;
  final double? prevMonthTotal;

  const ExpensesState({
    required this.year,
    required this.month,
    required this.expenses,
    required this.breakdown,
    required this.sixMonthTrend,
    required this.total,
    this.prevMonthTotal,
  });
}

class ExpensesNotifier extends FamilyAsyncNotifier<ExpensesState, String> {
  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  @override
  Future<ExpensesState> build(String arg) => _load();

  Future<ExpensesState> _load() async {
    final repo = getIt<ExpenseRepository>();
    final expenses = await repo.getExpensesByMonth(arg, _year, _month);
    final breakdown = await repo.getCategoryBreakdown(arg, _year, _month);
    final trend = await repo.getSixMonthTrend(arg);
    final total = await repo.getMonthlyTotal(arg, _year, _month);

    double? prev;
    final prevMonth = DateTime(_year, _month - 1);
    prev = await repo.getMonthlyTotal(arg, prevMonth.year, prevMonth.month);

    return ExpensesState(
      year: _year,
      month: _month,
      expenses: expenses,
      breakdown: breakdown,
      sixMonthTrend: trend,
      total: total,
      prevMonthTotal: prev,
    );
  }

  Future<void> prevMonth() async {
    final d = DateTime(_year, _month - 1);
    _year = d.year;
    _month = d.month;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> nextMonth() async {
    final now = DateTime.now();
    if (_year == now.year && _month == now.month) return;
    final d = DateTime(_year, _month + 1);
    _year = d.year;
    _month = d.month;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> addExpense(Expense expense) async {
    await getIt<ExpenseRepository>().insertExpense(expense);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> deleteExpense(String id) async {
    await getIt<ExpenseRepository>().deleteExpense(id);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final expensesProvider =
    AsyncNotifierProvider.family<ExpensesNotifier, ExpensesState, String>(
  ExpensesNotifier.new,
);
