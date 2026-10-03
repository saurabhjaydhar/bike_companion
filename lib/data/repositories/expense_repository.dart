import '../database/app_database.dart';
import '../models/expense.dart';
import '../../core/services/sync_service.dart';

class ExpenseRepository {
  final AppDatabase _db;

  ExpenseRepository(this._db);

  Future<List<Expense>> getExpensesByMonth(
      String bikeId, int year, int month) async {
    final db = await _db.db;
    final start = DateTime(year, month).millisecondsSinceEpoch;
    final end = DateTime(year, month + 1).millisecondsSinceEpoch;
    final rows = await db.query(
      'expenses',
      where: 'bike_id = ? AND date >= ? AND date < ?',
      whereArgs: [bikeId, start, end],
      orderBy: 'date DESC',
    );
    return rows.map(Expense.fromMap).toList();
  }

  Future<String> insertExpense(Expense expense) async {
    final db = await _db.db;
    await db.insert('expenses', expense.toMap());
    await SyncService.queueUpsert(db, 'expenses', expense.toMap());
    return expense.id;
  }

  Future<void> deleteExpense(String id) async {
    final db = await _db.db;
    await SyncService.queueDelete(db, 'expenses', id);
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getMonthlyTotal(String bikeId, int year, int month) async {
    final db = await _db.db;
    final start = DateTime(year, month).millisecondsSinceEpoch;
    final end = DateTime(year, month + 1).millisecondsSinceEpoch;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM expenses '
      'WHERE bike_id = ? AND date >= ? AND date < ?',
      [bikeId, start, end],
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<Map<String, double>> getCategoryBreakdown(
      String bikeId, int year, int month) async {
    final db = await _db.db;
    final start = DateTime(year, month).millisecondsSinceEpoch;
    final end = DateTime(year, month + 1).millisecondsSinceEpoch;
    final rows = await db.rawQuery(
      'SELECT category, SUM(amount) as total FROM expenses '
      'WHERE bike_id = ? AND date >= ? AND date < ? '
      'GROUP BY category',
      [bikeId, start, end],
    );
    return {
      for (final row in rows)
        row['category'] as String: (row['total'] as num).toDouble()
    };
  }

  Future<List<MonthSummary>> getSixMonthTrend(String bikeId) async {
    final db = await _db.db;
    final now = DateTime.now();
    final summaries = <MonthSummary>[];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      final start = DateTime(month.year, month.month).millisecondsSinceEpoch;
      final end =
          DateTime(month.year, month.month + 1).millisecondsSinceEpoch;
      final result = await db.rawQuery(
        'SELECT COALESCE(SUM(amount), 0) as total FROM expenses '
        'WHERE bike_id = ? AND date >= ? AND date < ?',
        [bikeId, start, end],
      );
      summaries.add(MonthSummary(
        year: month.year,
        month: month.month,
        total: (result.first['total'] as num).toDouble(),
      ));
    }
    return summaries;
  }

  Future<double> getYearTotal(String bikeId, int year) async {
    final db = await _db.db;
    final start = DateTime(year).millisecondsSinceEpoch;
    final end = DateTime(year + 1).millisecondsSinceEpoch;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM expenses '
      'WHERE bike_id = ? AND date >= ? AND date < ?',
      [bikeId, start, end],
    );
    return (result.first['total'] as num).toDouble();
  }
}
