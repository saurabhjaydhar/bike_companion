import '../database/app_database.dart';
import '../models/fuel_log.dart';
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
}
