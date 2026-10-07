import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/data/models/fuel_log.dart';
import 'package:garajo/features/fuel/fuel_prefill.dart';

FuelLog _log(int odometer, {double? amount}) => FuelLog(
      id: '$odometer',
      vehicleId: 'v',
      date: DateTime(2026),
      odometer: odometer,
      amount: amount,
    );

void main() {
  group('usualTripKm', () {
    test('is null with fewer than two fills', () {
      expect(usualTripKm([]), isNull);
      expect(usualTripKm([_log(1000)]), isNull);
    });

    test('takes the median gap, ignoring one odd trip', () {
      // Gaps: 200, 210, 900 (a road trip), 190.
      final logs = [_log(2500), _log(2300), _log(2090), _log(1190), _log(1000)];
      expect(usualTripKm(logs), 205);
    });
  });

  group('suggestOdometer', () {
    test('uses a reading newer than the last fill', () {
      expect(
        suggestOdometer(
            vehicleOdometer: 5230, lastLog: _log(5000), usualTrip: 200),
        5230,
      );
    });

    test('adds the usual trip to the last fill, rounded to 10 km', () {
      expect(
        suggestOdometer(
            vehicleOdometer: 5000, lastLog: _log(5000), usualTrip: 204),
        5200,
      );
    });

    test('leaves the field blank when there is nothing to go on', () {
      expect(suggestOdometer(vehicleOdometer: 0), isNull);
      expect(suggestOdometer(vehicleOdometer: 5000, lastLog: _log(5000)),
          isNull);
    });

    test('starts from the vehicle odometer before the first fill', () {
      expect(suggestOdometer(vehicleOdometer: 1200), 1200);
    });
  });

  group('amountChips', () {
    test('offers round defaults with no history', () {
      expect(amountChips([]), [200, 300, 500, 1000]);
    });

    test('puts the usual amount first in line, smallest first', () {
      final logs = [
        _log(3, amount: 450),
        _log(2, amount: 450),
        _log(1, amount: 300.4),
      ];
      expect(amountChips(logs), [200, 300, 450, 500]);
    });
  });
}
