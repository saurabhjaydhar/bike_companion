import '../database/app_database.dart';
import '../models/bike.dart';

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
    return bike.id;
  }

  Future<void> updateBike(Bike bike) async {
    final db = await _db.db;
    await db.update('bikes', bike.toMap(),
        where: 'id = ?', whereArgs: [bike.id]);
  }

  Future<void> deleteBike(String id) async {
    final db = await _db.db;
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
  }
}
