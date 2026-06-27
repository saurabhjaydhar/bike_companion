import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/database/app_database.dart';
import 'firestore_service.dart';

class SyncService {
  final AppDatabase _db;
  final FirestoreService _firestore;

  SyncService(this._db, this._firestore);

  /// Enqueue a local write for later Firestore sync.
  /// Call from repositories after any SQLite write.
  static Future<void> enqueue(
    Database db, {
    required String tableName,
    required String recordId,
    required String operation, // 'upsert' | 'delete'
    required Map<String, dynamic> payload,
  }) async {
    final id =
        '${tableName}_${recordId}_${DateTime.now().millisecondsSinceEpoch}';
    await db.insert(
      'pending_sync',
      {
        'id': id,
        'table_name': tableName,
        'record_id': recordId,
        'operation': operation,
        'payload_json': jsonEncode(payload),
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Push all queued operations to Firestore using user-scoped paths.
  /// Call when connectivity is restored.
  Future<void> pushPending() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return; // Must be signed in to sync.

    final database = await _db.db;
    final rows = await database.query('pending_sync', orderBy: 'created_at ASC');

    for (final row in rows) {
      try {
        final tableName = row['table_name'] as String;
        final operation = row['operation'] as String;
        final syncId = row['id'] as String;
        final recordId = row['record_id'] as String;
        final payload =
            jsonDecode(row['payload_json'] as String) as Map<String, dynamic>;

        if (operation == 'delete') {
          if (tableName == 'bikes') {
            await _firestore.deleteBike(uid, recordId);
          } else {
            final bikeId = payload['bike_id'] as String? ?? '';
            await _firestore.deleteRecord(uid, bikeId, tableName, recordId);
          }
        } else {
          if (tableName == 'bikes') {
            await _firestore.pushBike(uid, payload);
          } else {
            final bikeId = payload['bike_id'] as String? ?? '';
            await _firestore.pushRecord(uid, bikeId, tableName, payload);
          }
        }

        await database.delete(
            'pending_sync', where: 'id = ?', whereArgs: [syncId]);
      } catch (_) {
        break; // Stop on first failure — retry on next connectivity restore.
      }
    }
  }

  Future<int> pendingCount() async {
    final database = await _db.db;
    final result =
        await database.rawQuery('SELECT COUNT(*) as c FROM pending_sync');
    return (result.first['c'] as int?) ?? 0;
  }
}
