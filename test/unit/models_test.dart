import 'package:garajo/data/models/vehicle.dart';
import 'package:garajo/data/models/document.dart';
import 'package:garajo/data/models/expense.dart';
import 'package:garajo/data/models/fuel_log.dart';
import 'package:garajo/data/models/service_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2025, 6, 15, 12, 0, 0);
  final nowMs = now.millisecondsSinceEpoch;

  // ---------------------------------------------------------------------------
  // Vehicle model
  // ---------------------------------------------------------------------------
  group('Vehicle', () {
    final vehicle = Vehicle(
      id: 'b1',
      name: 'My Shine',
      brand: 'Honda',
      model: 'Shine 100',
      colourHex: '#1A56DB',
      regNumber: 'MH01AB1234',
      odometerCurrent: 12500,
      odometerOfficial: 12000,
      createdAt: now,
    );

    test('round-trips RC details through toMap/fromMap', () {
      final withRc = Vehicle(
        id: 'b9',
        name: 'Bullet',
        brand: 'Royal Enfield',
        model: 'Classic 350',
        colourHex: '#1A56DB',
        regNumber: 'MH12DE1234',
        odometerCurrent: 100,
        odometerOfficial: 100,
        createdAt: DateTime(2024, 1, 1),
        manufacturer: 'Royal Enfield',
        fuelType: 'Petrol',
        vehicleClass: 'M-Cycle',
        engineNumber: 'U3S5C1AB1234',
        chassisNumber: 'ME3U3S5C1AB123456',
      );
      final copy = Vehicle.fromMap(withRc.toMap());
      expect(copy.fuelType, 'Petrol');
      expect(copy.vehicleClass, 'M-Cycle');
      expect(copy.engineNumber, 'U3S5C1AB1234');
      expect(copy.chassisNumber, 'ME3U3S5C1AB123456');
      expect(copy.manufacturer, 'Royal Enfield');
    });

    test('colour getter parses hex correctly', () {
      final color = vehicle.colour;
      expect(color.r, closeTo(26 / 255, 0.01));
      expect(color.g, closeTo(86 / 255, 0.01));
      expect(color.b, closeTo(219 / 255, 0.01));
    });

    test('colour getter falls back on invalid hex', () {
      final bad = vehicle.copyWith(colourHex: 'NOT_A_HEX');
      expect(() => bad.colour, returnsNormally);
    });

    test('fromMap / toMap round-trip', () {
      final map = vehicle.toMap();
      final restored = Vehicle.fromMap(map);
      expect(restored.id, vehicle.id);
      expect(restored.name, vehicle.name);
      expect(restored.brand, vehicle.brand);
      expect(restored.colourHex, vehicle.colourHex);
      expect(restored.odometerCurrent, vehicle.odometerCurrent);
    });

    test('toMap encodes dates as millisecondsSinceEpoch', () {
      final map = vehicle.toMap();
      expect(map['created_at'], equals(nowMs));
      expect(map['insurance_expiry'], isNull);
    });

    test('fromMap decodes insurance_expiry', () {
      final futureMs =
          DateTime(2026, 1, 1).millisecondsSinceEpoch;
      final map = vehicle.toMap()..['insurance_expiry'] = futureMs;
      final restored = Vehicle.fromMap(map);
      expect(restored.insuranceExpiry?.year, 2026);
    });

    test('equality is id-based', () {
      final copy = vehicle.copyWith(name: 'Different Name');
      expect(copy, equals(vehicle));
    });
  });

  // ---------------------------------------------------------------------------
  // FuelLog model
  // ---------------------------------------------------------------------------
  group('FuelLog', () {
    final log = FuelLog(
      id: 'fl1',
      vehicleId: 'b1',
      date: now,
      odometer: 12000,
      litres: 4.5,
      amount: 450.0,
      fuelStation: 'HP Petrol',
      mileageCalculated: 42.2,
    );

    test('fromMap / toMap round-trip', () {
      final restored = FuelLog.fromMap(log.toMap());
      expect(restored.id, log.id);
      expect(restored.litres, log.litres);
      expect(restored.amount, log.amount);
      expect(restored.mileageCalculated, log.mileageCalculated);
      expect(restored.fuelStation, log.fuelStation);
    });

    test('optional fields survive null round-trip', () {
      final minimal = FuelLog(
          id: 'fl2', vehicleId: 'b1', date: now, odometer: 10000);
      final restored = FuelLog.fromMap(minimal.toMap());
      expect(restored.litres, isNull);
      expect(restored.amount, isNull);
      expect(restored.mileageCalculated, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // ServiceRecord model
  // ---------------------------------------------------------------------------
  group('ServiceRecord', () {
    final record = ServiceRecord(
      id: 'sr1',
      vehicleId: 'b1',
      date: now,
      serviceType: 'oil_change',
      odometer: 11000,
      cost: 350.0,
      notes: 'Used Motul 10W-40',
    );

    test('fromMap / toMap round-trip preserves all fields', () {
      final restored = ServiceRecord.fromMap(record.toMap());
      expect(restored.serviceType, record.serviceType);
      expect(restored.odometer, record.odometer);
      expect(restored.cost, record.cost);
      expect(restored.notes, record.notes);
    });

    test('nextDueKm and nextDueDate survive null round-trip', () {
      final map = record.toMap();
      final restored = ServiceRecord.fromMap(map);
      expect(restored.nextDueKm, isNull);
      expect(restored.nextDueDate, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Expense model
  // ---------------------------------------------------------------------------
  group('Expense', () {
    final expense = Expense(
      id: 'e1',
      vehicleId: 'b1',
      date: now,
      category: 'fuel',
      amount: 500.0,
      note: 'HP station',
    );

    test('fromMap / toMap round-trip', () {
      final restored = Expense.fromMap(expense.toMap());
      expect(restored.category, expense.category);
      expect(restored.amount, expense.amount);
      expect(restored.note, expense.note);
    });
  });

  // ---------------------------------------------------------------------------
  // VehicleDocument model
  // ---------------------------------------------------------------------------
  group('VehicleDocument', () {
    test('isExpired returns true when expiry in the past', () {
      final expired = VehicleDocument(
        id: 'd1',
        vehicleId: 'b1',
        type: 'insurance',
        title: 'Insurance',
        expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(expired.isExpired, isTrue);
    });

    test('isExpired returns false when expiry in the future', () {
      final valid = VehicleDocument(
        id: 'd2',
        vehicleId: 'b1',
        type: 'insurance',
        title: 'Insurance',
        expiryDate: DateTime.now().add(const Duration(days: 90)),
      );
      expect(valid.isExpired, isFalse);
    });

    test('isExpired returns false when no expiry date', () {
      final noExpiry = VehicleDocument(
        id: 'd3',
        vehicleId: 'b1',
        type: 'rc',
        title: 'RC Book',
      );
      expect(noExpiry.isExpired, isFalse);
    });

    test('daysUntilExpiry is null when no expiry', () {
      final doc = VehicleDocument(
          id: 'd4', vehicleId: 'b1', type: 'rc', title: 'RC Book');
      expect(doc.daysUntilExpiry, isNull);
    });

    test('daysUntilExpiry is positive for future expiry', () {
      final doc = VehicleDocument(
        id: 'd5',
        vehicleId: 'b1',
        type: 'insurance',
        title: 'Insurance',
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      );
      expect(doc.daysUntilExpiry, greaterThan(0));
    });

    test('fromMap / toMap round-trip', () {
      final doc = VehicleDocument(
        id: 'd6',
        vehicleId: 'b1',
        type: 'puc',
        title: 'PUC Certificate',
        expiryDate: DateTime(2026, 3, 15),
      );
      final restored = VehicleDocument.fromMap(doc.toMap());
      expect(restored.type, doc.type);
      expect(restored.expiryDate?.year, 2026);
    });
  });
}
