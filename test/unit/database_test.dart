import 'dart:io';

import 'package:bike_companion/core/services/restore_service.dart';
import 'package:bike_companion/data/database/app_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The schema as shipped in v1, frozen. Never edit — add a new snapshot for
/// each new version and an upgrade test from it.
const _schemaV1 = [
  '''CREATE TABLE bikes (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    variant TEXT,
    colour_hex TEXT NOT NULL DEFAULT '#1A56DB',
    reg_number TEXT NOT NULL,
    purchase_date INTEGER,
    odometer_current INTEGER NOT NULL DEFAULT 0,
    odometer_official INTEGER NOT NULL DEFAULT 0,
    insurance_expiry INTEGER,
    puc_expiry INTEGER,
    created_at INTEGER NOT NULL
  )''',
  '''CREATE TABLE fuel_logs (
    id TEXT PRIMARY KEY,
    bike_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    odometer INTEGER NOT NULL,
    litres REAL,
    amount REAL,
    fuel_station TEXT,
    mileage_calculated REAL,
    FOREIGN KEY (bike_id) REFERENCES bikes(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE service_records (
    id TEXT PRIMARY KEY,
    bike_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    service_type TEXT NOT NULL,
    odometer INTEGER NOT NULL,
    cost REAL,
    notes TEXT,
    next_due_km INTEGER,
    next_due_date INTEGER,
    FOREIGN KEY (bike_id) REFERENCES bikes(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE expenses (
    id TEXT PRIMARY KEY,
    bike_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    category TEXT NOT NULL,
    amount REAL NOT NULL,
    note TEXT,
    FOREIGN KEY (bike_id) REFERENCES bikes(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE documents (
    id TEXT PRIMARY KEY,
    bike_id TEXT NOT NULL,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    file_path TEXT,
    expiry_date INTEGER,
    FOREIGN KEY (bike_id) REFERENCES bikes(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE pending_sync (
    id TEXT PRIMARY KEY,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    operation TEXT NOT NULL,
    payload_json TEXT NOT NULL,
    created_at INTEGER NOT NULL
  )''',
];

const _tables = [
  'bikes',
  'fuel_logs',
  'service_records',
  'expenses',
  'documents',
  'pending_sync',
];

late DatabaseFactory factory;
late Directory tempDir;

Future<Map<String, List<String>>> columnsOf(Database db) async => {
  for (final table in _tables)
    table: [
      for (final c in await db.rawQuery('PRAGMA table_info($table)'))
        c['name'] as String,
    ],
};

Map<String, Object?> bikeRow(String id) => {
  'id': id,
  'name': 'Bullet',
  'brand': 'Royal Enfield',
  'model': 'Classic 350',
  'reg_number': 'MH12DE1234',
  'odometer_current': 12000,
  'insurance_expiry': DateTime(2027, 1, 31).millisecondsSinceEpoch,
  'created_at': DateTime(2024, 1, 1).millisecondsSinceEpoch,
};

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    factory = databaseFactoryFfi;
  });
  setUp(() => tempDir = Directory.systemTemp.createTempSync('db_test'));
  tearDown(() => tempDir.deleteSync(recursive: true));

  group('migrations', () {
    test('upgrading from v1 keeps data and matches a fresh install', () async {
      final path = join(tempDir.path, 'v1.db');
      final v1 = await factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, _) async {
            for (final sql in _schemaV1) {
              await db.execute(sql);
            }
          },
        ),
      );
      await v1.insert('bikes', bikeRow('b1'));
      await v1.insert('fuel_logs', {
        'id': 'f1',
        'bike_id': 'b1',
        'date': DateTime(2024, 2, 1).millisecondsSinceEpoch,
        'odometer': 12100,
        'amount': 500.0,
      });
      await v1.close();

      final upgraded = await AppDatabase.openAt(factory, path);
      final fresh =
          await AppDatabase.openAt(factory, join(tempDir.path, 'fresh.db'));

      expect(await upgraded.getVersion(), AppDatabase.schemaVersion);
      // Same columns, in the same order, as a fresh install.
      expect(await columnsOf(upgraded), await columnsOf(fresh));
      // Existing data untouched.
      final bike = (await upgraded.query('bikes')).single;
      expect(bike['name'], 'Bullet');
      expect(bike['odometer_current'], 12000);
      expect(bike['insurance_expiry'],
          DateTime(2027, 1, 31).millisecondsSinceEpoch);
      expect((await upgraded.query('fuel_logs')).single['amount'], 500.0);

      await upgraded.close();
      await fresh.close();
    });
  });

  group('restore from the cloud', () {
    late Database db;
    setUp(() async {
      db = await AppDatabase.openAt(factory, join(tempDir.path, 'r.db'));
    });
    tearDown(() => db.close());

    test('ignores fields the local schema does not have', () async {
      await writeRestoredData(db, {
        'bikes': [
          {...bikeRow('b1'), 'field_from_a_newer_app': 'x', 'tags': ['a']},
        ],
      });
      expect((await db.query('bikes')).single['name'], 'Bullet');
    });

    test('converts timestamps and booleans; keeps column defaults', () async {
      final when = DateTime(2025, 6, 1);
      await writeRestoredData(db, {
        // No colour_hex in the document.
        'bikes': [
          {...bikeRow('b1'), 'created_at': Timestamp.fromDate(when)},
        ],
        'documents': [
          {
            'id': 'd1',
            'bike_id': 'b1',
            'type': 'insurance',
            'title': 'Policy',
            'expiry_date': Timestamp.fromDate(when),
            'archived': true,
          },
        ],
      });
      final bike = (await db.query('bikes')).single;
      expect(bike['created_at'], when.millisecondsSinceEpoch);
      expect(bike['colour_hex'], '#1A56DB'); // default applied
      expect((await db.query('documents')).single['expiry_date'],
          when.millisecondsSinceEpoch);
    });

    test('skips incomplete rows instead of failing the restore', () async {
      await writeRestoredData(db, {
        // Child listed first: bikes are still written first (foreign key).
        'expenses': [
          {
            'id': 'e1',
            'bike_id': 'b1',
            'date': 1,
            'category': 'fuel',
            'amount': 300.0,
          },
          // Missing the required amount.
          {'id': 'e2', 'bike_id': 'b1', 'date': 1, 'category': 'fuel'},
        ],
        'bikes': [
          bikeRow('b1'),
          {...bikeRow('b2')}..remove('reg_number'),
        ],
      });
      expect((await db.query('bikes')).map((r) => r['id']), ['b1']);
      expect((await db.query('expenses')).map((r) => r['id']), ['e1']);
    });

    test('restoring twice replaces rather than duplicates', () async {
      final data = {
        'bikes': [bikeRow('b1')],
      };
      await writeRestoredData(db, data);
      await writeRestoredData(db, data);
      expect(await db.query('bikes'), hasLength(1));
    });
  });
}
