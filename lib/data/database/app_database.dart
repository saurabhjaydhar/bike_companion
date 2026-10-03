import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const int _version = 3;
  static const String _name = 'garajo.db';

  /// Database file of the app before the vehicle rename. Its data isn't
  /// carried over; the file is deleted on first open.
  static const String _legacyName = 'bike_companion.db';

  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  /// Wraps an already-open database, e.g. one from [openAt] in tests.
  AppDatabase.wrap(Database db) : _db = db;

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    await deleteDatabase(join(dir, _legacyName));
    return openAt(databaseFactory, join(dir, _name));
  }

  /// Current schema version; bump it with every migration in [_onUpgrade].
  static const int schemaVersion = _version;

  /// Opens the app database at [path], creating or upgrading it. Tests pass
  /// an FFI [factory] to run real SQLite on the desktop.
  static Future<Database> openAt(DatabaseFactory factory, String path) =>
      factory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: _version,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
        ),
      );

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles (
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
        reg_validity INTEGER,
        monthly_budget REAL,
        yearly_budget REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE fuel_logs (
        id TEXT PRIMARY KEY,
        vehicle_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        odometer INTEGER NOT NULL,
        litres REAL,
        amount REAL,
        fuel_station TEXT,
        mileage_calculated REAL,
        FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE service_records (
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
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        vehicle_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        note TEXT,
        FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        vehicle_id TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        file_path TEXT,
        expiry_date INTEGER,
        FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_sync (
        id TEXT PRIMARY KEY,
        table_name TEXT NOT NULL,
        record_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Indexes for fast queries
    await db.execute(
        'CREATE INDEX idx_fuel_vehicle_date ON fuel_logs(vehicle_id, date)');
    await db.execute(
        'CREATE INDEX idx_service_vehicle_date ON service_records(vehicle_id, date)');
    await db.execute(
        'CREATE INDEX idx_expense_vehicle_date ON expenses(vehicle_id, date)');
    await db.execute(
        'CREATE INDEX idx_document_vehicle ON documents(vehicle_id)');
    await db.execute(
        'CREATE INDEX idx_pending_sync_created ON pending_sync(created_at)');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // One step per version, plus a frozen schema snapshot and an upgrade
    // test in test/unit/database_test.dart.
    if (oldVersion < 2) {
      // v2: registration validity, for RC renewal reminders.
      await db.execute('ALTER TABLE vehicles ADD COLUMN reg_validity INTEGER');
    }
    if (oldVersion < 3) {
      // v3: spending budgets.
      await db.execute('ALTER TABLE vehicles ADD COLUMN monthly_budget REAL');
      await db.execute('ALTER TABLE vehicles ADD COLUMN yearly_budget REAL');
    }
  }

  Future<void> wipeAll() async {
    final database = await db;
    await database.transaction((txn) async {
      for (final table in [
        'pending_sync', 'documents', 'expenses',
        'service_records', 'fuel_logs', 'vehicles',
      ]) {
        await txn.delete(table);
      }
    });
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
