import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter/foundation.dart' show debugPrint;
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

    final vehicles = await _firestore.fetchVehicles(uid);

    // Fetch all sub-collections before opening the SQLite transaction.
    final children = <String, List<Map<String, dynamic>>>{
      for (final table in restoreChildTables) table: [],
    };
    for (final vehicle in vehicles) {
      final vehicleId = vehicle['id'] as String;
      for (final table in restoreChildTables) {
        children[table]!
            .addAll(await _firestore.fetchCollection(uid, vehicleId, table));
      }
    }

    await writeRestoredData(await _db.db, {'vehicles': vehicles, ...children});
    return true;
  }
}

/// Per-vehicle Firestore sub-collections, each restored into the local table
/// of the same name.
const restoreChildTables = [
  'fuel_logs',
  'service_records',
  'expenses',
  'documents',
];

/// A column of a local table, from `PRAGMA table_info`.
typedef TableColumn = ({String name, bool required});

/// Writes restored cloud documents into local tables in one transaction.
/// [rowsByTable] maps table name to Firestore documents; vehicles are written
/// first so child rows satisfy their foreign key. Rows that can't be stored
/// are skipped and logged rather than failing the whole restore.
Future<void> writeRestoredData(
  Database db,
  Map<String, List<Map<String, dynamic>>> rowsByTable,
) async {
  final order = ['vehicles', ...rowsByTable.keys.where((t) => t != 'vehicles')];
  await db.transaction((txn) async {
    for (final table in order) {
      final docs = rowsByTable[table];
      if (docs == null) continue;
      final columns = await _columnsOf(txn, table);
      var skipped = 0;
      for (final doc in docs) {
        final row = restoreRow(doc, columns);
        if (row == null) {
          skipped++;
          continue;
        }
        await txn.insert(
          table,
          row,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      if (skipped > 0) {
        debugPrint('Restore: skipped $skipped incomplete $table rows');
      }
    }
  });
}

Future<List<TableColumn>> _columnsOf(Transaction txn, String table) async {
  final info = await txn.rawQuery('PRAGMA table_info($table)');
  return [
    for (final c in info)
      (
        name: c['name'] as String,
        // NOT NULL without a default, or the primary key.
        required: (c['notnull'] == 1 && c['dflt_value'] == null) ||
            c['pk'] == 1,
      ),
  ];
}

/// Turns a Firestore document into a row for a local table.
///
/// Keeps only the table's columns — cloud documents are merged on every
/// sync, so they can carry fields this version of the app doesn't have.
/// Converts values SQLite can't store (booleans, timestamps) and drops
/// others (maps, lists). Returns null when a required column is missing.
Map<String, Object?>? restoreRow(
  Map<String, dynamic> doc,
  List<TableColumn> columns,
) {
  final row = <String, Object?>{};
  for (final column in columns) {
    final value = _sqlValue(doc[column.name]);
    if (value == null) {
      if (column.required) return null;
      if (!doc.containsKey(column.name)) continue; // let the default apply
    }
    row[column.name] = value;
  }
  return row;
}

Object? _sqlValue(Object? value) => switch (value) {
  null || String() || num() => value,
  bool() => value ? 1 : 0,
  Timestamp() => value.millisecondsSinceEpoch,
  DateTime() => value.millisecondsSinceEpoch,
  _ => null,
};
