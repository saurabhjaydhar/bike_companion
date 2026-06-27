import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static const int _version = 1;
  static const String _name = 'bike_companion.db';

  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), _name);
    return openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async => db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bikes (
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
      )
    ''');

    await db.execute('''
      CREATE TABLE fuel_logs (
        id TEXT PRIMARY KEY,
        bike_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        odometer INTEGER NOT NULL,
        litres REAL,
        amount REAL,
        fuel_station TEXT,
        mileage_calculated REAL,
        FOREIGN KEY (bike_id) REFERENCES bikes(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE service_records (
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
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        bike_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        note TEXT,
        FOREIGN KEY (bike_id) REFERENCES bikes(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        bike_id TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        file_path TEXT,
        expiry_date INTEGER,
        FOREIGN KEY (bike_id) REFERENCES bikes(id) ON DELETE CASCADE
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
        'CREATE INDEX idx_fuel_bike_date ON fuel_logs(bike_id, date)');
    await db.execute(
        'CREATE INDEX idx_service_bike_date ON service_records(bike_id, date)');
    await db.execute(
        'CREATE INDEX idx_expense_bike_date ON expenses(bike_id, date)');
    await db.execute(
        'CREATE INDEX idx_document_bike ON documents(bike_id)');
    await db.execute(
        'CREATE INDEX idx_pending_sync_created ON pending_sync(created_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migrations go here
  }

  Future<void> wipeAll() async {
    final database = await db;
    await database.transaction((txn) async {
      for (final table in [
        'pending_sync', 'documents', 'expenses',
        'service_records', 'fuel_logs', 'bikes',
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
