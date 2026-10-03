import '../database/app_database.dart';
import '../models/bike.dart';
import '../../core/services/sync_service.dart';

class BikeRepository {
  final AppDatabase _db;

  BikeRepository(this._db);

  Future<List<Bike>> getAllBikes() async {
    final db = await _db.db;
    final rows = await db.query('bikes', orderBy: 'created_at ASC');
    return rows.map(Bike.fromMap).toList();
  }

  Future<Bike?> getBikeById(String id) async {
    final db = await _db.db;
    final rows = await db.query('bikes', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Bike.fromMap(rows.first);
  }

  Future<String> insertBike(Bike bike) async {
    final db = await _db.db;
    await db.insert('bikes', bike.toMap());
    await SyncService.queueUpsert(db, 'bikes', bike.toMap());
    return bike.id;
  }

  Future<void> updateBike(Bike bike) async {
    final db = await _db.db;
    await db.update('bikes', bike.toMap(),
        where: 'id = ?', whereArgs: [bike.id]);
    await SyncService.queueUpsert(db, 'bikes', bike.toMap());
  }

  Future<void> deleteBike(String id) async {
    final db = await _db.db;
    // Child rows go with the bike (ON DELETE CASCADE) — delete them in the
    // cloud too, or they'd be left orphaned under the deleted bike.
    for (final table in SyncService.childTables) {
      final rows = await db.query(table,
          columns: ['id'], where: 'bike_id = ?', whereArgs: [id]);
      for (final row in rows) {
        await SyncService.queueDelete(db, table, row['id'] as String);
      }
    }
    await SyncService.queueDelete(db, 'bikes', id);
    await db.delete('bikes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateOdometer(String bikeId, int km) async {
    final db = await _db.db;
    await db.update(
      'bikes',
      {'odometer_current': km},
      where: 'id = ?',
      whereArgs: [bikeId],
    );
    final rows =
        await db.query('bikes', where: 'id = ?', whereArgs: [bikeId]);
    if (rows.isNotEmpty) {
      await SyncService.queueUpsert(db, 'bikes', Map.of(rows.first));
    }
  }
}
