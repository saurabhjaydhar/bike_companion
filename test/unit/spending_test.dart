import 'dart:io';

import 'package:garajo/core/services/spending.dart';
import 'package:garajo/data/database/app_database.dart';
import 'package:garajo/data/models/ledger_entry.dart';
import 'package:garajo/data/repositories/ledger_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

LedgerEntry entry(DateTime date, double amount,
        {String category = 'parts', LedgerSource source = LedgerSource.expense}) =>
    LedgerEntry(
      id: '${date.millisecondsSinceEpoch}$amount',
      vehicleId: 'v1',
      date: date,
      category: category,
      amount: amount,
      source: source,
    );

void main() {
  final now = DateTime(2026, 3, 15);

  group('SpendPeriod', () {
    test('months roll over year boundaries', () {
      const jan = SpendPeriod.month(2026, 1);
      expect(jan.previous, const SpendPeriod.month(2025, 12));
      expect(jan.end, DateTime(2026, 2));
      expect(const SpendPeriod.month(2025, 12).next, jan);
    });

    test('chart months: 6 ending this month, or the 12 of the year', () {
      expect(const SpendPeriod.month(2026, 2).chartMonths.first,
          DateTime(2025, 9));
      expect(const SpendPeriod.year(2025).chartMonths, hasLength(12));
    });

    test('switching kind keeps the year and picks a sensible month', () {
      expect(const SpendPeriod.month(2026, 3).switchTo(PeriodKind.year, now),
          const SpendPeriod.year(2026));
      expect(const SpendPeriod.year(2026).switchTo(PeriodKind.month, now),
          const SpendPeriod.month(2026, 3));
      expect(const SpendPeriod.year(2024).switchTo(PeriodKind.month, now),
          const SpendPeriod.month(2024, 12));
    });

    test('the ledger range covers the chart and the previous period', () {
      final month = ledgerRangeFor(const SpendPeriod.month(2026, 3));
      expect(month.from, DateTime(2025, 10));
      expect(month.to, DateTime(2026, 4));
      final year = ledgerRangeFor(const SpendPeriod.year(2026));
      expect(year.from, DateTime(2025));
      expect(year.to, DateTime(2027));
    });
  });

  group('summarize', () {
    final entries = [
      entry(DateTime(2026, 3, 2), 1000, category: 'fuel', source: LedgerSource.fuel),
      entry(DateTime(2026, 3, 10), 500),
      entry(DateTime(2026, 2, 5), 1000),
      entry(DateTime(2026, 1, 5), 2000),
    ];

    test('totals, change and categories for a month', () {
      final s = summarize(
        period: const SpendPeriod.month(2026, 3),
        entries: entries,
        readings: const [],
        now: now,
      );
      expect(s.total, 1500);
      expect(s.previousTotal, 1000);
      expect(s.changePercent, 50);
      expect(s.byCategory, {'fuel': 1000, 'parts': 500});
      expect(s.entries.first.date, DateTime(2026, 3, 10)); // newest first
    });

    test('average counts months from the first with spending', () {
      final s = summarize(
        period: const SpendPeriod.month(2026, 3),
        entries: entries,
        readings: const [],
        now: now,
      );
      // Oct–Dec had nothing: average of Jan, Feb and Mar.
      expect(s.averageMonthly, (2000 + 1000 + 1500) / 3);
    });

    test('year view: 12 bars, future months not averaged', () {
      final s = summarize(
        period: const SpendPeriod.year(2026),
        entries: entries,
        readings: const [],
        now: now,
      );
      expect(s.chart, hasLength(12));
      expect(s.chart[0].total, 2000);
      expect(s.total, 4500);
      expect(s.averageMonthly, 1500); // Jan–Mar only
      expect(s.changePercent, isNull); // nothing in 2025
    });

    test('cost per km and fuel cost per km', () {
      final s = summarize(
        period: const SpendPeriod.month(2026, 3),
        entries: entries,
        readings: [
          OdometerReading(DateTime(2026, 2, 20), 10000),
          OdometerReading(DateTime(2026, 3, 2), 10200),
          OdometerReading(DateTime(2026, 3, 12), 10500),
        ],
        now: now,
      );
      expect(s.kmDriven, 500);
      expect(s.costPerKm, 3); // 1500 / 500
      expect(s.fuelCostPerKm, 2); // 1000 / 500
    });
  });

  group('kmDriven', () {
    test('uses the first reading in range when none comes before', () {
      final km = kmDriven([
        OdometerReading(DateTime(2026, 3, 1), 1000),
        OdometerReading(DateTime(2026, 3, 20), 1300),
      ], DateTime(2026, 3), DateTime(2026, 4));
      expect(km, 300);
    });

    test('is null without readings in range', () {
      expect(
        kmDriven([OdometerReading(DateTime(2026, 1, 1), 900)],
            DateTime(2026, 3), DateTime(2026, 4)),
        isNull,
      );
    });
  });

  group('budgets', () {
    test('progress levels at 80 % and 100 %', () {
      expect(const BudgetProgress(700, 1000).level, BudgetLevel.ok);
      expect(const BudgetProgress(800, 1000).level, BudgetLevel.near);
      expect(const BudgetProgress(1000, 1000).level, BudgetLevel.over);
      expect(const BudgetProgress(1200, 1000).remaining, -200);
    });

    test('thresholds reached', () {
      expect(budgetThresholdsReached(799, 1000), isEmpty);
      expect(budgetThresholdsReached(850, 1000), [80]);
      expect(budgetThresholdsReached(1000, 1000), [80, 100]);
      expect(budgetThresholdsReached(5000, null), isEmpty);
    });

    test('suggests the recent average rounded up to 500', () {
      expect(
        suggestMonthlyBudget([
          MonthTotal(DateTime(2025, 11), 9000), // older than the last 3
          MonthTotal(DateTime(2025, 12), 2600),
          MonthTotal(DateTime(2026, 1), 0), // no spending: skipped
          MonthTotal(DateTime(2026, 2), 3100),
          MonthTotal(DateTime(2026, 3), 2900),
        ]),
        3000, // (2600 + 3100 + 2900) / 3 = 2866 → 3000
      );
      expect(suggestMonthlyBudget(const []), isNull);
    });
  });

  group('LedgerRepository', () {
    late Directory dir;
    late Database db;
    late LedgerRepository ledger;

    setUpAll(sqfliteFfiInit);
    setUp(() async {
      dir = Directory.systemTemp.createTempSync('ledger');
      db = await AppDatabase.openAt(databaseFactoryFfi, join(dir.path, 'l.db'));
      ledger = LedgerRepository(AppDatabase.wrap(db));
      await db.insert('vehicles', {
        'id': 'v1',
        'name': 'Bullet',
        'brand': 'Royal Enfield',
        'model': 'Classic 350',
        'reg_number': 'MH12DE1234',
        'created_at': 0,
      });
      final march = DateTime(2026, 3, 5).millisecondsSinceEpoch;
      await db.insert('expenses', {
        'id': 'e1', 'vehicle_id': 'v1', 'date': march,
        'category': 'parts', 'amount': 300.0,
      });
      await db.insert('fuel_logs', {
        'id': 'f1', 'vehicle_id': 'v1', 'date': march,
        'odometer': 1200, 'amount': 500.0, 'fuel_station': 'HP',
      });
      // Fill-up without an amount: not spending.
      await db.insert('fuel_logs', {
        'id': 'f2', 'vehicle_id': 'v1', 'date': march, 'odometer': 1300,
      });
      await db.insert('service_records', {
        'id': 's1', 'vehicle_id': 'v1', 'date': march,
        'service_type': 'oil_change', 'odometer': 1250, 'cost': 800.0,
      });
    });
    tearDown(() async {
      await db.close();
      dir.deleteSync(recursive: true);
    });

    test('combines expenses, fuel logs and service costs', () async {
      final entries = await ledger.entries(
          vehicleId: 'v1', from: DateTime(2026, 3), to: DateTime(2026, 4));
      expect({for (final e in entries) e.source: e.amount}, {
        LedgerSource.expense: 300,
        LedgerSource.fuel: 500,
        LedgerSource.service: 800,
      });
      expect(entries.firstWhere((e) => e.source == LedgerSource.fuel).category,
          'fuel');
      expect(
        await ledger.total(from: DateTime(2026, 3), to: DateTime(2026, 4)),
        1600,
      );
    });

    test('reads odometer readings from fuel logs and services', () async {
      final readings = await ledger.odometerReadings('v1');
      expect(readings.map((r) => r.km), containsAll([1200, 1250, 1300]));
    });
  });
}
