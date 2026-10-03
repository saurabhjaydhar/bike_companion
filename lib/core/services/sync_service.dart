import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/database/app_database.dart';
import 'firestore_service.dart';

class SyncService {
  final AppDatabase _db;
  final FirestoreService _firestore;

  SyncService(this._db, this._firestore);

  /// Called after every enqueue. Set at startup so changes upload right away.
  static void Function()? onEnqueued;

  /// Per-bike tables, stored in Firestore under the bike's document.
  static const childTables = [
    'fuel_logs',
    'service_records',
    'expenses',
    'documents',
  ];

  static const _backfillKey = 'sync_backfill_done_v1';

  /// Enqueue a local write for later Firestore sync.
  /// Call from repositories after any SQLite write.
  ///
  /// One queue entry per record: a newer write replaces an older one still
  /// waiting, so only the latest state is uploaded.
  static Future<void> enqueue(
    Database db, {
    required String tableName,
    required String recordId,
    required String operation, // 'upsert' | 'delete'
    required Map<String, dynamic> payload,
  }) async {
    final id = '${tableName}_$recordId';
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
    onEnqueued?.call();
  }

  /// Queues [row] (a model's `toMap()`) to be uploaded.
  static Future<void> queueUpsert(
    Database db,
    String table,
    Map<String, dynamic> row,
  ) => enqueue(
    db,
    tableName: table,
    recordId: row['id'] as String,
    operation: 'upsert',
    payload: row,
  );

  /// Queues the cloud delete of record [id]. Call before deleting it
  /// locally — child records need their bike_id to be found in Firestore.
  static Future<void> queueDelete(Database db, String table, String id) async {
    String? bikeId;
    if (table != 'bikes') {
      final rows = await db.query(
        table,
        columns: ['bike_id'],
        where: 'id = ?',
        whereArgs: [id],
      );
      if (rows.isEmpty) return;
      bikeId = rows.first['bike_id'] as String?;
    }
    await enqueue(
      db,
      tableName: table,
      recordId: id,
      operation: 'delete',
      payload: {'id': id, 'bike_id': ?bikeId},
    );
  }

  /// Starts syncing: uploads whenever a user is signed in, and once queues
  /// all existing local data — records written before sync was wired up
  /// were never uploaded.
  void start() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) pushPending();
    });
    _backfillOnce();
  }

  Future<void> _backfillOnce() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_backfillKey) ?? false) return;
    final db = await _db.db;
    for (final table in ['bikes', ...childTables]) {
      for (final row in await db.query(table)) {
        await queueUpsert(db, table, Map.of(row));
      }
    }
    await prefs.setBool(_backfillKey, true);
  }

  bool _pushing = false;
  bool _pushAgain = false;

  /// Push all queued operations to Firestore using user-scoped paths.
  /// Safe to call often: overlapping calls run one more pass instead of
  /// pushing in parallel.
  Future<void> pushPending() async {
    if (_pushing) {
      _pushAgain = true;
      return;
    }
    _pushing = true;
    try {
      do {
        _pushAgain = false;
        await _pushOnce();
      } while (_pushAgain);
    } finally {
      _pushing = false;
    }
  }

  Future<void> _pushOnce() async {
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
