import '../database/app_database.dart';
import '../models/ledger_entry.dart';

/// Read-only view of everything spent on vehicles: expenses, fuel logs and
/// service costs, combined at query time.
class LedgerRepository {
  final AppDatabase _db;

  LedgerRepository(this._db);

  static const _ledger = '''
    SELECT id, vehicle_id, date, category, amount, note, 'expense' AS source
      FROM expenses
    UNION ALL
    SELECT id, vehicle_id, date, 'fuel', amount, fuel_station, 'fuel'
      FROM fuel_logs WHERE amount > 0
    UNION ALL
    SELECT id, vehicle_id, date, 'service', cost, service_type, 'service'
      FROM service_records WHERE cost > 0
  ''';

  /// Entries dated in [from, to), newest first. All vehicles when
  /// [vehicleId] is null.
  Future<List<LedgerEntry>> entries({
    String? vehicleId,
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await _db.db;
    final rows = await db.rawQuery(
      'SELECT * FROM ($_ledger) WHERE date >= ? AND date < ?'
      '${vehicleId == null ? '' : ' AND vehicle_id = ?'}'
      ' ORDER BY date DESC',
      [
        from.millisecondsSinceEpoch,
        to.millisecondsSinceEpoch,
        ?vehicleId,
      ],
    );
    return rows.map(LedgerEntry.fromMap).toList();
  }

  /// Total spent in [from, to); all vehicles when [vehicleId] is null.
  Future<double> total({
    String? vehicleId,
    required DateTime from,
    required DateTime to,
  }) async {
    final db = await _db.db;
    final rows = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM ($_ledger)'
      ' WHERE date >= ? AND date < ?'
      '${vehicleId == null ? '' : ' AND vehicle_id = ?'}',
      [from.millisecondsSinceEpoch, to.millisecondsSinceEpoch, ?vehicleId],
    );
    return (rows.first['total'] as num).toDouble();
  }

  /// Odometer readings from fuel logs and services, oldest first.
  Future<List<OdometerReading>> odometerReadings(String vehicleId) async {
    final db = await _db.db;
    final rows = await db.rawQuery(
      'SELECT date, odometer FROM fuel_logs WHERE vehicle_id = ? '
      'UNION ALL '
      'SELECT date, odometer FROM service_records WHERE vehicle_id = ? '
      'ORDER BY date ASC',
      [vehicleId, vehicleId],
    );
    return [
      for (final r in rows)
        OdometerReading(
          DateTime.fromMillisecondsSinceEpoch(r['date'] as int),
          r['odometer'] as int,
        ),
    ];
  }
}
