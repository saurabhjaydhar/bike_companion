import '../database/app_database.dart';
import '../models/document.dart';
import '../../core/services/sync_service.dart';

class DocumentRepository {
  final AppDatabase _db;

  DocumentRepository(this._db);

  Future<List<VehicleDocument>> getDocuments(String vehicleId) async {
    final db = await _db.db;
    final rows = await db.query(
      'documents',
      where: 'vehicle_id = ?',
      whereArgs: [vehicleId],
      orderBy: 'expiry_date ASC',
    );
    return rows.map(VehicleDocument.fromMap).toList();
  }

  Future<String> insertDocument(VehicleDocument doc) async {
    final db = await _db.db;
    await db.insert('documents', doc.toMap());
    await SyncService.queueUpsert(db, 'documents', doc.toMap());
    return doc.id;
  }

  Future<void> updateDocument(VehicleDocument doc) async {
    final db = await _db.db;
    await db.update('documents', doc.toMap(),
        where: 'id = ?', whereArgs: [doc.id]);
    await SyncService.queueUpsert(db, 'documents', doc.toMap());
  }

  Future<void> deleteDocument(String id) async {
    final db = await _db.db;
    await SyncService.queueDelete(db, 'documents', id);
    await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<VehicleDocument>> getExpiringDocuments({int withinDays = 30}) async {
    final db = await _db.db;
    final now = DateTime.now().millisecondsSinceEpoch;
    final threshold =
        DateTime.now().add(Duration(days: withinDays)).millisecondsSinceEpoch;
    final rows = await db.query(
      'documents',
      where: 'expiry_date IS NOT NULL AND expiry_date >= ? AND expiry_date <= ?',
      whereArgs: [now, threshold],
      orderBy: 'expiry_date ASC',
    );
    return rows.map(VehicleDocument.fromMap).toList();
  }
}
