import 'package:bike_companion/core/services/rc_scan_service.dart';
import 'package:bike_companion/data/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidRegNumber', () {
    test('accepts state and Bharat series numbers', () {
      expect(isValidRegNumber('MH12DE1234'), isTrue);
      expect(isValidRegNumber('DL1SAB1234'), isTrue);
      expect(isValidRegNumber('22BH1234AA'), isTrue);
    });

    test('rejects malformed numbers', () {
      expect(isValidRegNumber(''), isFalse);
      expect(isValidRegNumber('MH12'), isFalse);
      expect(isValidRegNumber('1234MH12'), isFalse);
    });

    test('normalizeRegNumber strips spaces, dots and hyphens', () {
      expect(normalizeRegNumber('mh 12-de.1234'), 'MH12DE1234');
    });
  });

  group('vehicleFromRcJson (Gemini output)', () {
    test('maps fields, normalizes numbers and brand', () {
      final v = vehicleFromRcJson({
        'is_rc': true,
        'registration_number': 'MH 12 DE 1234',
        'brand': null,
        'manufacturer': 'ROYAL ENFIELD (UNIT OF EICHER MOTORS LTD)',
        'model': 'CLASSIC 350',
        'fuel_type': 'PETROL',
        'vehicle_class': 'M-Cycle/Scooter (2WN)',
        'registration_date': '2021-03-15',
        'engine_number': 'u3s5c1 ab1234',
        'chassis_number': 'ME3U3S5C1AB123456',
      })!;
      expect(v.rcNumber, 'MH12DE1234');
      expect(v.brand, 'Royal Enfield');
      expect(v.model, 'CLASSIC 350');
      expect(v.fuelType, 'PETROL');
      expect(v.registrationDate, DateTime(2021, 3, 15));
      expect(v.engineNumber, 'U3S5C1AB1234');
      expect(v.chassisNumber, 'ME3U3S5C1AB123456');
    });

    test('returns null when the photo is not an RC', () {
      expect(vehicleFromRcJson({'is_rc': false}), isNull);
    });

    test('treats empty and "null" strings as missing', () {
      final v = vehicleFromRcJson({
        'is_rc': true,
        'registration_number': '',
        'model': 'null',
        'registration_date': 'unknown',
      })!;
      expect(v.rcNumber, '');
      expect(v.model, isNull);
      expect(v.registrationDate, isNull);
    });
  });

  group('parseRcText (on-device OCR)', () {
    test('reads a smart-card style RC', () {
      const text = '''
INDIAN UNION VEHICLE REGISTRATION CERTIFICATE
Regn. Number
MH12DE1234
Date of Regn: 15/03/2021
Chassis Number: ME3U3S5C1AB123456
Engine / Motor Number: U3S5C1AB1234
Fuel: PETROL
Maker's Name: ROYAL ENFIELD (UNIT OF EICHER MOTORS LTD)
Model Name: CLASSIC 350
Vehicle Class: M-CYCLE/SCOOTER(2WN)
''';
      final v = parseRcText(text);
      expect(v.rcNumber, 'MH12DE1234');
      expect(v.registrationDate, DateTime(2021, 3, 15));
      expect(v.chassisNumber, 'ME3U3S5C1AB123456');
      expect(v.engineNumber, 'U3S5C1AB1234');
      expect(v.fuelType, 'Petrol');
      expect(v.brand, 'Royal Enfield');
      expect(v.model, 'CLASSIC 350');
      expect(v.vehicleClass, contains('CYCLE'));
    });

    test('handles labels with the value on the next line and month names', () {
      const text = '''
REGISTRATION NO
KA 03 MX 4521
REG. DATE
04-Jan-2019
MAKER
HONDA MOTORCYCLE AND SCOOTER INDIA
MODEL
ACTIVA 6G
''';
      final v = parseRcText(text);
      expect(v.rcNumber, 'KA03MX4521');
      expect(v.registrationDate, DateTime(2019, 1, 4));
      expect(v.brand, 'Honda');
      expect(v.model, 'ACTIVA 6G');
    });

    test('reads a Bharat series number', () {
      expect(parseRcText('Regn No: 22 BH 1234 AA').rcNumber, '22BH1234AA');
    });

    test('returns empty fields for unrelated text', () {
      final v = parseRcText('Hello world');
      expect(v.rcNumber, '');
      expect(v.brand, isNull);
      expect(v.chassisNumber, isNull);
    });
  });
}
