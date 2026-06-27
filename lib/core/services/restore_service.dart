import 'package:sqflite/sqflite.dart';

import '../../data/database/app_database.dart';
import 'firestore_service.dart';

/// Checks if the signed-in user has existing Firestore data and, if so,
/// restores it into local SQLite (the source of truth).
/// Idempotent — safe to call multiple times (uses ConflictAlgorithm.replace).
class RestoreService {
  final AppDatabase _db;
  final FirestoreService _firestore;

  RestoreService(this._db, this._firestore);

  /// Returns true when data was restored (existing account found).
  /// Returns false when no Firestore data exists (new user).
  Future<bool> restoreIfNeeded(String uid) async {
    final hasData = await _firestore.userHasData(uid);
    if (!hasData) return false;

    final bikes = await _firestore.fetchBikes(uid);

    // Fetch all sub-collections before opening the SQLite transaction.
    final fuelLogs = <Map<String, dynamic>>[];
    final serviceRecords = <Map<String, dynamic>>[];
    final expenses = <Map<String, dynamic>>[];
    final documents = <Map<String, dynamic>>[];

    for (final bike in bikes) {
      final bikeId = bike['id'] as String;
      fuelLogs.addAll(
          await _firestore.fetchCollection(uid, bikeId, 'fuel_logs'));
      serviceRecords.addAll(
          await _firestore.fetchCollection(uid, bikeId, 'service_records'));
      expenses.addAll(
          await _firestore.fetchCollection(uid, bikeId, 'expenses'));
      documents.addAll(
          await _firestore.fetchCollection(uid, bikeId, 'documents'));
    }

    final database = await _db.db;
    await database.transaction((txn) async {
      for (final row in bikes) {
        await txn.insert('bikes', row,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final row in fuelLogs) {
        await txn.insert('fuel_logs', row,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final row in serviceRecords) {
        await txn.insert('service_records', row,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final row in expenses) {
        await txn.insert('expenses', row,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final row in documents) {
        await txn.insert('documents', row,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });

    return true;
  }
}
