import 'dart:ui' show Rect;

import 'package:bike_companion/core/services/rc_ocr_layout.dart';
import 'package:bike_companion/core/services/rc_scan_service.dart';
import 'package:bike_companion/shared/widgets/colour_picker.dart';
import 'package:flutter_test/flutter_test.dart';

/// One OCR line: words 10px per character, 20px tall, 6px apart.
List<OcrWord> line(String text, double left, double top) {
  final words = <OcrWord>[];
  var x = left;
  for (final word in text.split(' ')) {
    words.add(OcrWord(word, Rect.fromLTWH(x, top, word.length * 10.0, 20)));
    x += word.length * 10.0 + 6;
  }
  return words;
}

String raw(List<List<OcrWord>> lines) =>
    lines.map((l) => l.map((w) => w.text).join(' ')).join('\n');

// A Form 23 / 23A smart card (Uttarakhand), upright. Values are made up.
// Lines are in the awkward order ML Kit can return them: rows joined across
// columns, and values before their labels.
final front = [
  [
    ...line('UK07AB1234', 150, 125),
    ...line('12-Jan-2025', 330, 125),
    ...line('11-Jan-2040', 500, 125),
  ],
  [
    ...line('Regn. No', 150, 100),
    ...line('Date of Regn', 330, 100),
    ...line('Regn.Validity', 500, 100),
  ],
  line('MD626AN16S2A01234', 150, 185),
  line('Chassis No', 150, 160),
  line('Engine No', 150, 220),
  line('AN1DS2401234', 150, 245),
  line('Owner Name', 150, 280),
  line('A KUMAR', 150, 305),
  line('Address', 150, 340),
  line('1 MAIN ROAD, SOMEWHERE-263153', 150, 365),
  line('Tax upto', 20, 400),
  line('One Time', 20, 425),
  line('Fuel Used', 20, 460),
  line('PETROL(E20)', 20, 485),
  line('Emission Norms', 20, 520),
  line('BHARAT STAGE VI', 20, 545),
];

final back = [
  [...line('Vehicle Class', 230, 60), ...line('Financier Name', 480, 60)],
  [...line('M-CYCLE/SCOOTER', 230, 85), ...line('SOME FINANCE', 480, 85)],
  line('Regn.No', 20, 100),
  [...line('Maker’s Name', 230, 110), ...line('LTD.', 480, 110)],
  line('UK07AB1234', 20, 125),
  line('TVS MOTOR COMPANY LTD', 230, 135),
  [...line('Month & Yr.of Mfg', 20, 160), ...line('Model name', 230, 160)],
  [...line('12/2024', 20, 185), ...line('TVS RONIN', 230, 185)],
  [...line('Wheel Base(mm)', 20, 220), ...line('Colour', 230, 210)],
  [...line('1357', 20, 245), ...line('LTNG BLACK', 230, 235)],
  line('Body type', 230, 260),
  line('SOLO WITH PILLION', 230, 285),
];

// The back as actually photographed: the left column runs right up to the
// middle one, so ML Kit joins "Month & Yr.of Mfg" and "TVS RONIN" into one
// line with almost no gap, and other rows across the two columns.
final backTight = [
  line('Vehicle Class', 331, 215),
  line('M-CYCLE/SCOOTER', 331, 240),
  line('Maker’s Name', 331, 266),
  [...line('Regn.No', 170, 298), ...line('TVS MOTOR COMPANY LTD', 331, 292)],
  [...line('UK07AB1234', 170, 324), ...line('Model name', 331, 324)],
  [...line('Month & Yr.of Mfg', 170, 356), ...line('TVS RONIN', 331, 350)],
  [...line('12/2024', 170, 382), ...line('Colour', 331, 384)],
  [...line('Wheel Base(mm)', 170, 414), ...line('LTNG BLACK', 331, 408)],
  [...line('1357', 170, 440), ...line('Body type', 331, 440)],
  line('SOLO WITH PILLION', 331, 466),
  line('Financier Name', 700, 466),
  line('SOME FINANCE', 700, 492),
];

void main() {
  group('uprightRotation', () {
    test('turns bottom-to-top text clockwise by 90°', () {
      expect(uprightRotation([-90, -88, -91, 2]), 90);
    });
    test('turns top-to-bottom text by 270°', () {
      expect(uprightRotation([90, 89]), 270);
    });
    test('turns upside-down text by 180°', () {
      expect(uprightRotation([179, -178]), 180);
    });
    test('leaves upright text alone', () {
      expect(uprightRotation([0, 3, -2]), 0);
      expect(uprightRotation([]), 0);
    });
  });

  group('layoutRcText', () {
    test('pairs each label with the value below it', () {
      final text = layoutRcText(front, isRcLabelLine);
      expect(text, contains('Regn. No\nUK07AB1234\n'));
      expect(text, contains('Date of Regn\n12-Jan-2025\n'));
      expect(text, contains('Chassis No\nMD626AN16S2A01234\n'));
      expect(text, contains('Fuel Used\nPETROL(E20)\n'));
    });
  });

  group('reading a Form 23 / 23A smart card from OCR words', () {
    test('front side', () {
      final v = parseRcText(rcTextFromWords(front, raw: raw(front)));
      expect(v.rcNumber, 'UK07AB1234');
      expect(v.registrationDate, DateTime(2025, 1, 12));
      expect(v.chassisNumber, 'MD626AN16S2A01234');
      expect(v.engineNumber, 'AN1DS2401234');
      expect(v.fuelType, 'Petrol');
    });

    test('back side', () {
      final v = parseRcText(rcTextFromWords(back, raw: raw(back)));
      expect(v.rcNumber, 'UK07AB1234');
      expect(v.manufacturer, 'TVS MOTOR COMPANY LTD');
      expect(v.brand, 'TVS');
      expect(v.model, 'RONIN');
      expect(v.vehicleClass, 'M-CYCLE/SCOOTER');
      expect(v.colour, 'LTNG BLACK');
      expect(v.registrationDate, isNull);
    });

    test('back side with a label run into the model beside it', () {
      final text = layoutRcText(backTight, isRcLabelLine);
      expect(text, contains('Model name\nTVS RONIN\n'));
      expect(text, contains('Month & Yr.of Mfg\n12/2024\n'));
      expect(text, contains('Regn.No\nUK07AB1234\n'));

      final v = parseRcText(rcTextFromWords(backTight, raw: raw(backTight)));
      expect(v.model, 'RONIN');
      expect(v.manufacturer, 'TVS MOTOR COMPANY LTD');
      expect(v.rcNumber, 'UK07AB1234');
      expect(v.colour, 'LTNG BLACK');
      expect(v.vehicleClass, 'M-CYCLE/SCOOTER');
      expect(v.registrationDate, isNull);
    });

    test('strips label text that OCR ran into a value', () {
      expect(
        parseRcText('Model name\nMonth & Yr.of Mfg TVS RONIN').model,
        'RONIN',
      );
      final gemini = vehicleFromRcJson({
        'manufacturer': 'TVS MOTOR COMPANY LTD',
        'model': 'Month & Yr. of Mfg TVS RONIN',
      })!;
      expect(gemini.model, 'RONIN');
    });

    test('both sides together fill every RC field', () {
      final v = mergeRcScans(
        parseRcText(rcTextFromWords(front, raw: raw(front))),
        parseRcText(rcTextFromWords(back, raw: raw(back))),
      );
      expect(v.rcNumber, 'UK07AB1234');
      expect(v.registrationDate, DateTime(2025, 1, 12));
      expect(v.chassisNumber, 'MD626AN16S2A01234');
      expect(v.engineNumber, 'AN1DS2401234');
      expect(v.fuelType, 'Petrol');
      expect(v.manufacturer, 'TVS MOTOR COMPANY LTD');
      expect(v.brand, 'TVS');
      expect(v.model, 'RONIN');
      expect(v.vehicleClass, 'M-CYCLE/SCOOTER');
      expect(ColourPicker.hexForName(v.colour), '#111827');
    });
  });

  group('ColourPicker.hexForName', () {
    test('maps RC colour names to the nearest swatch', () {
      expect(ColourPicker.hexForName('LTNG BLACK'), '#111827');
      expect(ColourPicker.hexForName('ROYAL BLUE'), '#1A56DB');
      expect(ColourPicker.hexForName('Maroon'), '#EF4444');
      expect(ColourPicker.hexForName('SILVER'), isNull);
      expect(ColourPicker.hexForName(null), isNull);
    });
  });
}
