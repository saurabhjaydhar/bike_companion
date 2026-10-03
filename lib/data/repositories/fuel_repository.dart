import '../database/app_database.dart';
import '../models/fuel_log.dart';
import '../models/expense.dart';
import '../../core/services/sync_service.dart';

class FuelRepository {
  final AppDatabase _db;

  FuelRepository(this._db);

  Future<List<FuelLog>> getFuelLogs(
    String vehicleId, {
    int? limit,
    int offset = 0,
  }) async {
    final db = await _db.db;
    final rows = await db.query(
      'fuel_logs',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',
      limit: limit,
      offset: offset,
    );
    return rows.map(FuelLog.fromMap).toList();
  }

  Future<String> insertFuelLog(FuelLog log) async {
    final db = await _db.db;
    await db.insert('fuel_logs', log.toMap());
    await SyncService.queueUpsert(db, 'fuel_logs', log.toMap());
    return log.id;
  }

  Future<FuelLog?> getLastFuelLog(String vehicleId) async {
    final db = await _db.db;
    final rows = await db.query(
      'fuel_logs',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : FuelLog.fromMap(rows.first);
  }

  Future<double?> getAverageMileage(String vehicleId, {int lastN = 5}) async {
    final db = await _db.db;
    final rows = await db.query(
      'fuel_logs',
      columns: ['mileage_calculated'],
      where: 'vehicle_id = ? AND mileage_calculated IS NOT NULL',
      whereArgs: [vehicleId],
      orderBy: 'date DESC',
      limit: lastN,
    );
    if (rows.isEmpty) return null;
    final values =
        rows.map((r) => r['mileage_calculated'] as double).toList();
    return values.reduce((a, b) => a + b) / values.length;
  }

  Future<double> getMonthlyFuelCost(
      String vehicleId, int year, int month) async {
    final db = await _db.db;
    final start = DateTime(year, month).millisecondsSinceEpoch;
    final end = DateTime(year, month + 1).millisecondsSinceEpoch;
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) as total FROM fuel_logs '
      'WHERE vehicle_id = ? AND date >= ? AND date < ? AND amount IS NOT NULL',
      [vehicleId, start, end],
    );
    return (result.first['total'] as num).toDouble();
  }

  Future<List<MonthSummary>> getSixMonthFuelTrend(String vehicleId) async {
    final db = await _db.db;
    final now = DateTime.now();
    final summaries = <MonthSummary>[];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      final start = DateTime(month.year, month.month).millisecondsSinceEpoch;
      final end =
          DateTime(month.year, month.month + 1).millisecondsSinceEpoch;
      final result = await db.rawQuery(
        'SELECT COALESCE(SUM(amount), 0) as total FROM fuel_logs '
        'WHERE vehicle_id = ? AND date >= ? AND date < ? AND amount IS NOT NULL',
        [vehicleId, start, end],
      );
      summaries.add(MonthSummary(
        year: month.year,
        month: month.month,
        total: (result.first['total'] as num).toDouble(),
      ));
    }
    return summaries;
  }
}
