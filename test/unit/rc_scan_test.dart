import 'package:bike_companion/core/services/rc_scan_service.dart';
import 'package:bike_companion/data/models/rc_details.dart';
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
      final v = rcDetailsFromJson({
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
      expect(v.fuelType, 'Petrol');
      expect(v.registrationDate, DateTime(2021, 3, 15));
      expect(v.engineNumber, 'U3S5C1AB1234');
      expect(v.chassisNumber, 'ME3U3S5C1AB123456');
    });

    test('returns null when the photo is not an RC', () {
      expect(rcDetailsFromJson({'is_rc': false}), isNull);
    });

    test('treats empty and "null" strings as missing', () {
      final v = rcDetailsFromJson({
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

  group('maker / model mix-ups (Gemini output)', () {
    RcDetails? read(String? manufacturer, String? model) => rcDetailsFromJson({
          'is_rc': true,
          'registration_number': 'MH12DE1234',
          'manufacturer': manufacturer,
          'model': model,
        });

    test('drops a model that is just the maker\'s name', () {
      final v = read('HONDA MOTORCYCLE AND SCOOTER INDIA PVT LTD',
          'HONDA MOTORCYCLE AND SCOOTER INDIA PVT LTD')!;
      expect(v.manufacturer, 'HONDA MOTORCYCLE AND SCOOTER INDIA PVT LTD');
      expect(v.model, isNull);
      expect(v.brand, 'Honda');
    });

    test('swaps maker and model when they come back reversed', () {
      final v = read('ACTIVA 6G', 'HONDA MOTORCYCLE AND SCOOTER INDIA PVT LTD')!;
      expect(v.manufacturer, 'HONDA MOTORCYCLE AND SCOOTER INDIA PVT LTD');
      expect(v.model, 'ACTIVA 6G');
      expect(v.brand, 'Honda');
    });

    test('keeps a correct pair untouched', () {
      final v = read('ROYAL ENFIELD (UNIT OF EICHER MOTORS LTD)', 'CLASSIC 350')!;
      expect(v.model, 'CLASSIC 350');
      expect(v.brand, 'Royal Enfield');
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

    test('reads short smart-card labels with the value on the next line', () {
      const text = '''
Regn. No.
MH 12 DE 1234
Date of Regn.
15-Mar-2021
Regn. Validity
14-Mar-2036
Chassis Number
ME3U3S5C1AB123456
Engine No
U3S5C1AB1234
''';
      final v = parseRcText(text);
      expect(v.rcNumber, 'MH12DE1234');
      expect(v.registrationDate, DateTime(2021, 3, 15));
      expect(v.chassisNumber, 'ME3U3S5C1AB123456');
      expect(v.engineNumber, 'U3S5C1AB1234');
    });

    test('reads abbreviated labels on one line', () {
      const text = 'Regn. No: KA03MX4521  Regd. Date: 04/01/2019\n'
          'Ch. No: ME4JC36L1234567  E. No: JC36E1234567';
      final v = parseRcText(text);
      expect(v.rcNumber, 'KA03MX4521');
      expect(v.registrationDate, DateTime(2019, 1, 4));
      expect(v.chassisNumber, 'ME4JC36L1234567');
      expect(v.engineNumber, 'JC36E1234567');
    });

    test('reads a labelled registration number despite OCR noise', () {
      // Label and value run together.
      expect(parseRcText('Regn. NoMH12DE1234').rcNumber, 'MH12DE1234');
      // Hyphenated, with a trailing field on the same line.
      expect(parseRcText('Regn. No. MH-12-DE-1234 Date of Regn. 15/03/2021')
          .rcNumber, 'MH12DE1234');
      // OCR read 1 as I and 0 as O.
      expect(parseRcText('Regn. No.\nMH12DEI234').rcNumber, 'MH12DE1234');
      expect(parseRcText('Regn. No: MHO2AB1O23').rcNumber, 'MH02AB1023');
    });

    test('reads values printed in a separate column from their labels', () {
      const text = 'Regn. No.\nDate of Regn.\nMH12DE1234\n15/03/2021';
      final v = parseRcText(text);
      expect(v.rcNumber, 'MH12DE1234');
      expect(v.registrationDate, DateTime(2021, 3, 15));
    });

    test('does not put the maker into the model (column layout)', () {
      const text = '''
Maker's Name
Model Name
ROYAL ENFIELD (UNIT OF EICHER MOTORS LTD)
CLASSIC 350
''';
      final v = parseRcText(text);
      expect(v.manufacturer, 'ROYAL ENFIELD (UNIT OF EICHER MOTORS LTD)');
      expect(v.model, 'CLASSIC 350');
      expect(v.brand, 'Royal Enfield');
    });

    test('reads "Maker\'s Class" as the model, not the maker', () {
      const text = "Maker: HERO MOTOCORP LTD\nMaker's Class: SPLENDOR PLUS";
      final v = parseRcText(text);
      expect(v.manufacturer, 'HERO MOTOCORP LTD');
      expect(v.model, 'SPLENDOR PLUS');
    });

    test('prefers the labelled registration number', () {
      const text = 'Dealer: MH01AB0001 Motors\nRegn. Number: MH12DE1234';
      expect(parseRcText(text).rcNumber, 'MH12DE1234');
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

  group('two-sided smart card', () {
    const back = RcDetails(
        rcNumber: '', brand: 'Honda', model: 'Shine', vehicleClass: 'MCWG');
    const front = RcDetails(
      rcNumber: 'MH12DE1234',
      fuelType: 'Petrol',
      engineNumber: 'JC36E1234567',
      chassisNumber: 'ME4JC36L1234567',
      model: 'CB SHINE',
    );

    test('merge fills gaps and keeps the first side\'s values', () {
      final v = mergeRcScans(back, front);
      expect(v.rcNumber, 'MH12DE1234');
      expect(v.brand, 'Honda');
      expect(v.model, 'Shine');
      expect(v.vehicleClass, 'MCWG');
      expect(v.fuelType, 'Petrol');
      expect(v.engineNumber, 'JC36E1234567');
      expect(v.chassisNumber, 'ME4JC36L1234567');
    });
  });

  // Layout of a Form 23A smart card (Uttarakhand) — values are made up.
  group('Form 23A smart card', () {
    // ML Kit may return the top row of labels as one line ...
    const frontRows = '''
State Transport Department
Certificate of Registration(Form 23)
Regn. No Date of Regn Regn.Validity Owner Sr.No
UK07AB1234 12-Jan-2025 11-Jan-2040 1
Chassis No
MD626AN16S2A01234
Engine No
AN1DS2401234
Owner Name
A KUMAR
Son/Daughter/Wife of
B KUMAR
Address
1 MAIN ROAD, SOMEWHERE-263153
Tax upto
One Time
Fuel Used
PETROL(E20)
Emission Norms
BHARAT STAGE VI
''';
    // ... or as one block per field.
    const frontBlocks = '''
Regn. No
UK07AB1234
Date of Regn
12-Jan-2025
Regn.Validity
11-Jan-2040
Chassis No
MD626AN16S2A01234
Engine No
AN1DS2401234
''';
    const back = '''
Regn.No
UK07AB1234
Month & Yr.of Mfg
12/2024
Wheel Base(mm)
1357
Vehicle Class
M-CYCLE/SCOOTER
Maker’s Name
TVS MOTOR COMPANY LTD
Model name
TVS RONIN
Colour
LTNG BLACK
Body type
SOLO WITH PILLION
Financier Name
SOME FINANCE LTD.
''';

    for (final (name, text) in [('rows', frontRows), ('blocks', frontBlocks)]) {
      test('reads the front ($name)', () {
        final v = parseRcText(text);
        expect(v.rcNumber, 'UK07AB1234');
        expect(v.registrationDate, DateTime(2025, 1, 12));
        expect(v.chassisNumber, 'MD626AN16S2A01234');
        expect(v.engineNumber, 'AN1DS2401234');
      });
    }

    test('reads fuel from the front', () {
      expect(parseRcText(frontRows).fuelType, 'Petrol');
    });

    test('reads the back, with a curly apostrophe in "Maker’s"', () {
      final v = parseRcText(back);
      expect(v.rcNumber, 'UK07AB1234');
      expect(v.manufacturer, 'TVS MOTOR COMPANY LTD');
      expect(v.brand, 'TVS');
      // Brand prefix dropped, so the vehicle isn't named "TVS TVS RONIN".
      expect(v.model, 'RONIN');
      expect(v.vehicleClass, 'M-CYCLE/SCOOTER');
      expect(v.registrationDate, isNull); // "Month & Yr. of Mfg" is not it
    });

    test('reads the registration validity from both readers', () {
      expect(parseRcText(frontRows).regValidity, DateTime(2040, 1, 11));
      final gemini = rcDetailsFromJson({
        'registration_number': 'UK07AB1234',
        'registration_validity': '11-Jan-2040', // as printed
      })!;
      expect(gemini.regValidity, DateTime(2040, 1, 11));
    });

    test('Gemini output also drops the brand prefix from the model', () {
      final v = rcDetailsFromJson({
        'manufacturer': 'TVS MOTOR COMPANY LTD',
        'model': 'TVS RONIN',
      })!;
      expect(v.model, 'RONIN');
      expect(v.brand, 'TVS');
    });

    test('scores upright RC text above garbled sideways text', () {
      expect(rcTextScore(frontRows), greaterThanOrEqualTo(uprightRcScore));
      expect(rcTextScore(back), greaterThanOrEqualTo(uprightRcScore));
      // Roughly what ML Kit returns for a card photographed sideways.
      expect(rcTextScore('N\nI3N\nnbaH\n6TOE\nE\n1'), lessThan(uprightRcScore));
    });
  });
}
