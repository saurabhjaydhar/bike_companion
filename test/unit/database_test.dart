import 'dart:io';

import 'package:bike_companion/core/services/restore_service.dart';
import 'package:bike_companion/data/database/app_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The schema as shipped in v1, frozen. Never edit — when the schema
/// changes, add `_schemaV2` etc. plus an upgrade test from the previous one.
const _schemaV1 = [
  '''CREATE TABLE vehicles (
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
    created_at INTEGER NOT NULL,
    manufacturer TEXT,
    fuel_type TEXT,
    vehicle_class TEXT,
    engine_number TEXT,
    chassis_number TEXT
  )''',
  '''CREATE TABLE fuel_logs (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    odometer INTEGER NOT NULL,
    litres REAL,
    amount REAL,
    fuel_station TEXT,
    mileage_calculated REAL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE service_records (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    service_type TEXT NOT NULL,
    odometer INTEGER NOT NULL,
    cost REAL,
    notes TEXT,
    next_due_km INTEGER,
    next_due_date INTEGER,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE expenses (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    category TEXT NOT NULL,
    amount REAL NOT NULL,
    note TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE documents (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    file_path TEXT,
    expiry_date INTEGER,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
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

/// v2: + vehicles.reg_validity.
const _schemaV2 = [
  '''CREATE TABLE vehicles (
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
    created_at INTEGER NOT NULL,
    manufacturer TEXT,
    fuel_type TEXT,
    vehicle_class TEXT,
    engine_number TEXT,
    chassis_number TEXT,
    reg_validity INTEGER
  )''',
  '''CREATE TABLE fuel_logs (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    odometer INTEGER NOT NULL,
    litres REAL,
    amount REAL,
    fuel_station TEXT,
    mileage_calculated REAL,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE service_records (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    service_type TEXT NOT NULL,
    odometer INTEGER NOT NULL,
    cost REAL,
    notes TEXT,
    next_due_km INTEGER,
    next_due_date INTEGER,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE expenses (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    category TEXT NOT NULL,
    amount REAL NOT NULL,
    note TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
  )''',
  '''CREATE TABLE documents (
    id TEXT PRIMARY KEY,
    vehicle_id TEXT NOT NULL,
    type TEXT NOT NULL,
    title TEXT NOT NULL,
    file_path TEXT,
    expiry_date INTEGER,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
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
  'vehicles',
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

Map<String, Object?> vehicleRow(String id) => {
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

  /// Creates a database at [path] from a frozen schema snapshot.
  Future<Database> openSnapshot(
    String path,
    int version,
    List<String> schema,
  ) => factory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: version,
      onCreate: (db, _) async {
        for (final sql in schema) {
          await db.execute(sql);
        }
      },
    ),
  );

  group('migrations', () {
    // Fails when the schema changes without a version bump, a migration
    // and a new snapshot.
    test('a fresh install matches the latest schema snapshot', () async {
      final snapshot =
          await openSnapshot(join(tempDir.path, 'v2.db'), 2, _schemaV2);
      final fresh =
          await AppDatabase.openAt(factory, join(tempDir.path, 'fresh.db'));

      expect(AppDatabase.schemaVersion, 2);
      expect(await fresh.getVersion(), AppDatabase.schemaVersion);
      expect(await columnsOf(fresh), await columnsOf(snapshot));

      await snapshot.close();
      await fresh.close();
    });

    test('upgrading from v1 keeps data and matches a fresh install', () async {
      final path = join(tempDir.path, 'v1.db');
      final v1 = await openSnapshot(path, 1, _schemaV1);
      await v1.insert('vehicles', vehicleRow('v1'));
      await v1.close();

      final upgraded = await AppDatabase.openAt(factory, path);
      final fresh =
          await AppDatabase.openAt(factory, join(tempDir.path, 'fresh.db'));

      expect(await upgraded.getVersion(), AppDatabase.schemaVersion);
      expect(await columnsOf(upgraded), await columnsOf(fresh));
      final row = (await upgraded.query('vehicles')).single;
      expect(row['name'], 'Bullet');
      expect(row['reg_validity'], isNull);

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
        'vehicles': [
          {...vehicleRow('b1'), 'field_from_a_newer_app': 'x', 'tags': ['a']},
        ],
      });
      expect((await db.query('vehicles')).single['name'], 'Bullet');
    });

    test('converts timestamps and booleans; keeps column defaults', () async {
      final when = DateTime(2025, 6, 1);
      await writeRestoredData(db, {
        // No colour_hex in the document.
        'vehicles': [
          {...vehicleRow('b1'), 'created_at': Timestamp.fromDate(when)},
        ],
        'documents': [
          {
            'id': 'd1',
            'vehicle_id': 'b1',
            'type': 'insurance',
            'title': 'Policy',
            'expiry_date': Timestamp.fromDate(when),
            'archived': true,
          },
        ],
      });
      final vehicle = (await db.query('vehicles')).single;
      expect(vehicle['created_at'], when.millisecondsSinceEpoch);
      expect(vehicle['colour_hex'], '#1A56DB'); // default applied
      expect((await db.query('documents')).single['expiry_date'],
          when.millisecondsSinceEpoch);
    });

    test('skips incomplete rows instead of failing the restore', () async {
      await writeRestoredData(db, {
        // Child listed first: vehicles are still written first (foreign key).
        'expenses': [
          {
            'id': 'e1',
            'vehicle_id': 'b1',
            'date': 1,
            'category': 'fuel',
            'amount': 300.0,
          },
          // Missing the required amount.
          {'id': 'e2', 'vehicle_id': 'b1', 'date': 1, 'category': 'fuel'},
        ],
        'vehicles': [
          vehicleRow('b1'),
          {...vehicleRow('b2')}..remove('reg_number'),
        ],
      });
      expect((await db.query('vehicles')).map((r) => r['id']), ['b1']);
      expect((await db.query('expenses')).map((r) => r['id']), ['e1']);
    });

    test('restoring twice replaces rather than duplicates', () async {
      final data = {
        'vehicles': [vehicleRow('b1')],
      };
      await writeRestoredData(db, data);
      await writeRestoredData(db, data);
      expect(await db.query('vehicles'), hasLength(1));
    });
  });
}
