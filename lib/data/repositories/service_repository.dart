import '../database/app_database.dart';
import '../models/service_record.dart';
import '../../core/services/sync_service.dart';

class ServiceRepository {
  final AppDatabase _db;

  ServiceRepository(this._db);

  Future<List<ServiceRecord>> getServiceHistory(String bikeId) async {
    final db = await _db.db;
    final rows = await db.query(
      'service_records',
      where: 'bike_id = ?',
      whereArgs: [bikeId],
      orderBy: 'date DESC',
    );
    return rows.map(ServiceRecord.fromMap).toList();
  }

  Future<String> insertService(ServiceRecord record) async {
    final db = await _db.db;
    await db.insert('service_records', record.toMap());
    await SyncService.queueUpsert(db, 'service_records', record.toMap());
    return record.id;
  }

  Future<void> updateService(ServiceRecord record) async {
    final db = await _db.db;
    await db.update('service_records', record.toMap(),
        where: 'id = ?', whereArgs: [record.id]);
    await SyncService.queueUpsert(db, 'service_records', record.toMap());
  }

  Future<void> deleteService(String id) async {
    final db = await _db.db;
    await SyncService.queueDelete(db, 'service_records', id);
    await db.delete('service_records', where: 'id = ?', whereArgs: [id]);
  }

  /// Returns service items where current odometer has passed nextDueKm.
  Future<List<ServiceRecord>> getOverdueServices(
      String bikeId, int currentOdometer) async {
    final db = await _db.db;
    final rows = await db.query(
      'service_records',
      where: 'bike_id = ? AND next_due_km IS NOT NULL AND next_due_km <= ?',
      whereArgs: [bikeId, currentOdometer],
      orderBy: 'next_due_km ASC',
    );
    return rows.map(ServiceRecord.fromMap).toList();
  }

  Future<ServiceRecord?> getNextDueService(String bikeId) async {
    final db = await _db.db;
    final rows = await db.query(
      'service_records',
      where: 'bike_id = ? AND next_due_km IS NOT NULL',
      whereArgs: [bikeId],
      orderBy: 'next_due_km ASC',
      limit: 1,
    );
    return rows.isEmpty ? null : ServiceRecord.fromMap(rows.first);
  }

  /// Returns the most recent record for each service type.
  Future<Map<String, ServiceRecord>> getLatestPerType(String bikeId) async {
    final db = await _db.db;
    final rows = await db.rawQuery(
      '''
      SELECT * FROM service_records
      WHERE bike_id = ? AND id IN (
        SELECT id FROM service_records s2
        WHERE s2.bike_id = service_records.bike_id
          AND s2.service_type = service_records.service_type
        ORDER BY date DESC LIMIT 1
      )
      ''',
      [bikeId],
    );
    return {
      for (final row in rows)
        row['service_type'] as String: ServiceRecord.fromMap(row)
    };
  }
}
