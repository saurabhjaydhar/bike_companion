import 'dart:convert';
import 'dart:io';

import 'package:garajo/core/services/sync_service.dart';
import 'package:garajo/data/database/app_database.dart';
import 'package:garajo/data/models/vehicle.dart';
import 'package:garajo/data/models/expense.dart';
import 'package:garajo/data/models/fuel_log.dart';
import 'package:garajo/data/repositories/vehicle_repository.dart';
import 'package:garajo/data/repositories/expense_repository.dart';
import 'package:garajo/data/repositories/fuel_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

late Directory tempDir;
late Database db;
late AppDatabase appDb;

Future<List<Map<String, Object?>>> queue() =>
    db.query('pending_sync', orderBy: 'created_at ASC');

Map<String, dynamic> payloadOf(Map<String, Object?> row) =>
    jsonDecode(row['payload_json'] as String) as Map<String, dynamic>;

Vehicle vehicle(String id, {int odometer = 1000}) => Vehicle(
  id: id,
  name: 'Bullet',
  brand: 'Royal Enfield',
  model: 'Classic 350',
  colourHex: '#1A56DB',
  regNumber: 'MH12DE1234',
  odometerCurrent: odometer,
  odometerOfficial: odometer,
  createdAt: DateTime(2024, 1, 1),
);

void main() {
  setUpAll(sqfliteFfiInit);
  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('sync_test');
    db = await AppDatabase.openAt(databaseFactoryFfi, join(tempDir.path, 'a.db'));
    appDb = AppDatabase.wrap(db);
  });
  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  test('saving a vehicle queues it for upload', () async {
    await VehicleRepository(appDb).insertVehicle(vehicle('b1'));
    final q = await queue();
    expect(q.single['operation'], 'upsert');
    expect(q.single['table_name'], 'vehicles');
    expect(payloadOf(q.single)['name'], 'Bullet');
  });

  test('only the latest state of a record is queued', () async {
    final repo = VehicleRepository(appDb);
    await repo.insertVehicle(vehicle('b1'));
    await repo.updateOdometer('b1', 1500);
    await repo.updateOdometer('b1', 2000);
    final q = await queue();
    expect(q, hasLength(1));
    expect(payloadOf(q.single)['odometer_current'], 2000);
  });

  test('deleting a record queues a delete with its vehicle id', () async {
    await VehicleRepository(appDb).insertVehicle(vehicle('b1'));
    final expenses = ExpenseRepository(appDb);
    await expenses.insertExpense(Expense(
      id: 'e1',
      vehicleId: 'b1',
      date: DateTime(2024, 2, 1),
      category: 'fuel',
      amount: 300,
    ));
    await expenses.deleteExpense('e1');
    final entry =
        (await queue()).singleWhere((r) => r['record_id'] == 'e1');
    expect(entry['operation'], 'delete');
    expect(payloadOf(entry)['vehicle_id'], 'b1');
  });

  test('deleting a vehicle also deletes its records in the cloud', () async {
    final repo = VehicleRepository(appDb);
    await repo.insertVehicle(vehicle('b1'));
    await FuelRepository(appDb).insertFuelLog(FuelLog(
      id: 'f1',
      vehicleId: 'b1',
      date: DateTime(2024, 2, 1),
      odometer: 1100,
      amount: 500,
    ));
    await repo.deleteVehicle('b1');
    final deletes = {
      for (final r in await queue())
        if (r['operation'] == 'delete') r['record_id'],
    };
    expect(deletes, {'b1', 'f1'});
    expect(await db.query('fuel_logs'), isEmpty); // cascaded locally
  });

  test('notifies the uploader after each change', () async {
    var calls = 0;
    SyncService.onEnqueued = () => calls++;
    addTearDown(() => SyncService.onEnqueued = null);
    await VehicleRepository(appDb).insertVehicle(vehicle('b1'));
    expect(calls, 1);
  });
}
