import '../database/app_database.dart';
import '../models/vehicle.dart';
import '../../core/services/sync_service.dart';

class VehicleRepository {
  final AppDatabase _db;

  VehicleRepository(this._db);

  Future<List<Vehicle>> getAllVehicles() async {
    final db = await _db.db;
    final rows = await db.query('vehicles', orderBy: 'created_at ASC');
    return rows.map(Vehicle.fromMap).toList();
  }

  Future<Vehicle?> getVehicleById(String id) async {
    final db = await _db.db;
    final rows = await db.query('vehicles', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Vehicle.fromMap(rows.first);
  }

  Future<String> insertVehicle(Vehicle vehicle) async {
    final db = await _db.db;
    await db.insert('vehicles', vehicle.toMap());
    await SyncService.queueUpsert(db, 'vehicles', vehicle.toMap());
    return vehicle.id;
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    final db = await _db.db;
    await db.update('vehicles', vehicle.toMap(),
        where: 'id = ?', whereArgs: [vehicle.id]);
    await SyncService.queueUpsert(db, 'vehicles', vehicle.toMap());
  }

  Future<void> deleteVehicle(String id) async {
    final db = await _db.db;
    // Child rows go with the vehicle (ON DELETE CASCADE) — delete them in the
    // cloud too, or they'd be left orphaned under the deleted vehicle.
    for (final table in SyncService.childTables) {
      final rows = await db.query(table,
          columns: ['id'], where: 'vehicle_id = ?', whereArgs: [id]);
      for (final row in rows) {
        await SyncService.queueDelete(db, table, row['id'] as String);
      }
    }
    await SyncService.queueDelete(db, 'vehicles', id);
    await db.delete('vehicles', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateOdometer(String vehicleId, int km) async {
    final db = await _db.db;
    await db.update(
      'vehicles',
      {'odometer_current': km},
      where: 'id = ?',
      whereArgs: [vehicleId],
    );
    final rows =
        await db.query('vehicles', where: 'id = ?', whereArgs: [vehicleId]);
    if (rows.isNotEmpty) {
      await SyncService.queueUpsert(db, 'vehicles', Map.of(rows.first));
    }
  }
}
