import 'dart:convert';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../data/models/vehicle.dart';
import '../constants/app_constants.dart';

enum RcScanSource { gemini, onDevice }

class RcScanResult {
  final Vehicle? vehicle;
  final RcScanSource source;

  const RcScanResult({required this.vehicle, required this.source});

  /// True when at least the registration number or the make/model was read.
  bool get found =>
      vehicle != null &&
      (vehicle!.rcNumber.isNotEmpty ||
          vehicle!.brand != null ||
          vehicle!.model != null);
}

/// Reads an RC (registration certificate) photo into a [Vehicle].
///
/// With [allowCloud], the photo goes to Gemini through Firebase AI Logic —
/// no API key ships in the app. Otherwise, or if that fails (offline, AI Logic
/// not enabled), the text is read on-device with ML Kit and parsed locally.
class RcScanService {
  /// Gemini model used for reading RC photos. Override at build time with
  /// `--dart-define=GEMINI_MODEL=...` when Google retires or replaces it.
  static const geminiModel =
      String.fromEnvironment('GEMINI_MODEL', defaultValue: 'gemini-2.5-flash');

  Future<RcScanResult> scan(String imagePath, {required bool allowCloud}) async {
    if (allowCloud) {
      try {
        final vehicle = await _scanWithGemini(imagePath);
        if (vehicle != null) {
          return RcScanResult(vehicle: vehicle, source: RcScanSource.gemini);
        }
      } catch (_) {
        // Fall through to on-device recognition.
      }
    }
    return RcScanResult(
      vehicle: await _scanOnDevice(imagePath),
      source: RcScanSource.onDevice,
    );
  }

  Future<Vehicle?> _scanWithGemini(String imagePath) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: geminiModel,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: _rcSchema,
      ),
    );
    final bytes = await File(imagePath).readAsBytes();
    final response = await model.generateContent([
      Content.multi([
        TextPart(_rcPrompt),
        InlineDataPart(_mimeType(imagePath), bytes),
      ]),
    ]);
    final text = response.text;
    if (text == null || text.isEmpty) return null;
    return vehicleFromRcJson(jsonDecode(text) as Map<String, dynamic>);
  }

  Future<Vehicle?> _scanOnDevice(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result =
          await recognizer.processImage(InputImage.fromFilePath(imagePath));
      return parseRcText(result.text);
    } catch (_) {
      return null;
    } finally {
      await recognizer.close();
    }
  }

  static String _mimeType(String path) {
    final p = path.toLowerCase();
    if (p.endsWith('.png')) return 'image/png';
    if (p.endsWith('.webp')) return 'image/webp';
    if (p.endsWith('.heic') || p.endsWith('.heif')) return 'image/heic';
    return 'image/jpeg';
  }

  // Only vehicle fields are requested — never the owner's name or address.
  static const _rcPrompt = '''
This image should be an Indian vehicle Registration Certificate (RC): a smart card, an RC book page, or a digital RC (mParivahan/DigiLocker).
Extract only the vehicle details listed in the schema. Do NOT extract the owner's name, father's name, or address.
Rules:
- Copy values exactly as printed. If a field is not clearly visible, return null. Never guess.
- registration_number: without spaces or hyphens, e.g. MH12DE1234.
- brand: the consumer brand (e.g. "Royal Enfield", "Honda", "TVS"); manufacturer: the maker's full name as printed.
- Dates in YYYY-MM-DD.
- Set is_rc to false if the image is not a vehicle registration certificate.
''';

  static final _rcSchema = Schema.object(
    properties: {
      'is_rc': Schema.boolean(),
      'registration_number': Schema.string(nullable: true),
      'brand': Schema.string(nullable: true),
      'manufacturer': Schema.string(nullable: true),
      'model': Schema.string(nullable: true),
      'variant': Schema.string(nullable: true),
      'fuel_type': Schema.string(nullable: true),
      'vehicle_class': Schema.string(nullable: true),
      'registration_date': Schema.string(nullable: true),
      'engine_number': Schema.string(nullable: true),
      'chassis_number': Schema.string(nullable: true),
    },
  );
}

final rcScanServiceProvider = Provider<RcScanService>((ref) => RcScanService());

// ---------------------------------------------------------------------------
// Parsing — pure functions, unit-tested
// ---------------------------------------------------------------------------

String normalizeRegNumber(String raw) =>
    raw.replaceAll(RegExp(r'[\s\-.]'), '').toUpperCase();

/// Matches a known brand name (any case) to its display form, e.g.
/// "ROYAL ENFIELD (UNIT OF EICHER MOTORS)" → "Royal Enfield".
String? canonicalBrand(String? raw) {
  if (raw == null) return null;
  final upper = raw.toUpperCase();
  for (final brand in kIndianBrands) {
    if (brand == 'Other') continue;
    if (upper.contains(brand.toUpperCase())) return brand;
  }
  if (upper.contains('EICHER')) return 'Royal Enfield';
  if (upper.contains('HERO')) return 'Hero';
  if (upper.contains('TVS')) return 'TVS';
  return null;
}

/// Converts Gemini's structured output into a [Vehicle]. Returns null when
/// the photo wasn't an RC.
Vehicle? vehicleFromRcJson(Map<String, dynamic> json) {
  if (json['is_rc'] == false) return null;
  String? str(String key) {
    final v = json[key]?.toString().trim();
    return (v == null || v.isEmpty || v.toLowerCase() == 'null') ? null : v;
  }

  final manufacturer = str('manufacturer');
  final brand = canonicalBrand(str('brand')) ??
      canonicalBrand(manufacturer) ??
      str('brand');
  return Vehicle(
    rcNumber: normalizeRegNumber(str('registration_number') ?? ''),
    manufacturer: manufacturer,
    brand: brand,
    model: str('model'),
    variant: str('variant'),
    fuelType: str('fuel_type'),
    vehicleClass: str('vehicle_class'),
    registrationDate: DateTime.tryParse(str('registration_date') ?? ''),
    engineNumber: str('engine_number')?.replaceAll(' ', '').toUpperCase(),
    chassisNumber: str('chassis_number')?.replaceAll(' ', '').toUpperCase(),
  );
}

final _regNumber = RegExp(
    r'\b([A-Z]{2})[\s\-]?(\d{1,2})[\s\-]?([A-Z]{1,3})[\s\-]?(\d{4})\b');
final _bharatSeries = RegExp(r'\b(\d{2})[\s\-]?BH[\s\-]?(\d{4})[\s\-]?([A-Z]{1,2})\b');
final _vin = RegExp(r'\b(?=[A-HJ-NPR-Z0-9]*\d)(?=[A-HJ-NPR-Z0-9]*[A-Z])[A-HJ-NPR-Z0-9]{17}\b');
final _date = RegExp(
    r'\b(\d{1,2})[\/\-. ](\d{1,2}|[A-Za-z]{3})[\/\-. ](\d{4})\b');

const _months = {
  'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
  'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12,
};

DateTime? _parseDate(String text) {
  final m = _date.firstMatch(text);
  if (m == null) return null;
  final day = int.parse(m.group(1)!);
  final rawMonth = m.group(2)!;
  final month =
      int.tryParse(rawMonth) ?? _months[rawMonth.toUpperCase()];
  final year = int.parse(m.group(3)!);
  if (month == null || month < 1 || month > 12 || day < 1 || day > 31) {
    return null;
  }
  return DateTime(year, month, day);
}

/// Best-effort parser for OCR text from an RC. Labels differ between states
/// and card versions, so each field is looked up by a few label variants and
/// taken either from the same line (after ':') or from the next line.
Vehicle parseRcText(String text) {
  final lines = text
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
  final upper = text.toUpperCase();

  String? valueAfter(RegExp label) {
    for (var i = 0; i < lines.length; i++) {
      final m = label.firstMatch(lines[i].toUpperCase());
      if (m == null) continue;
      final rest = lines[i]
          .substring(m.end)
          .replaceFirst(RegExp(r'^[\s:.\-]+'), '')
          .trim();
      if (rest.isNotEmpty) return rest;
      if (i + 1 < lines.length) return lines[i + 1];
    }
    return null;
  }

  String? token(String? value, {int minLength = 5}) {
    if (value == null) return null;
    final t = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9 ]'), ' ').trim();
    final parts = t.split(RegExp(r'\s+'));
    // Prefer one alphanumeric token; join a split number like "ABC 12345".
    for (final p in parts) {
      if (p.length >= minLength && RegExp(r'\d').hasMatch(p)) return p;
    }
    final joined = parts.join();
    return joined.length >= minLength && RegExp(r'\d').hasMatch(joined)
        ? joined
        : null;
  }

  // Registration number
  String rc = '';
  final bh = _bharatSeries.firstMatch(upper);
  final reg = _regNumber.firstMatch(upper);
  if (bh != null) {
    rc = '${bh.group(1)}BH${bh.group(2)}${bh.group(3)}';
  } else if (reg != null) {
    rc = '${reg.group(1)}${reg.group(2)!.padLeft(2, '0')}'
        '${reg.group(3)}${reg.group(4)}';
  }

  // Chassis / engine numbers
  final chassis = token(valueAfter(RegExp(r'CHASSIS|CH\.?\s*NO')), minLength: 10) ??
      _vin.firstMatch(upper.replaceAll(' ', ''))?.group(0);
  final engine = token(valueAfter(RegExp(r'ENGINE|ENG\.?\s*NO|MOTOR\s*NO')));

  // Dates
  final regDateText =
      valueAfter(RegExp(r'(DATE\s*OF\s*REG|REG(N|ISTRATION)?\.?\s*DATE|REGD\.?\s*DATE)'));
  final registrationDate =
      regDateText != null ? _parseDate(regDateText) : null;

  // Maker / model
  final manufacturer =
      valueAfter(RegExp(r"MAKER'?S?\s*NAME|MANUFACTURER|\bMFR\b|\bMAKER\b"));
  final model = valueAfter(RegExp(r"MODEL\s*NAME|MAKER'?S?\s*CLASS|\bMODEL\b"));

  // Fuel
  String? fuel;
  for (final f in const ['ELECTRIC', 'PETROL', 'DIESEL', 'CNG', 'LPG']) {
    if (upper.contains(f)) {
      fuel = f == 'CNG' || f == 'LPG'
          ? f
          : '${f[0]}${f.substring(1).toLowerCase()}';
      break;
    }
  }

  // Vehicle class
  final vehicleClass = valueAfter(RegExp(r'VEHICLE\s*CLASS|VEH\.?\s*CLASS|CLASS\s*OF\s*VEH')) ??
      RegExp(r'M[\-\s]?CYCLE(/SCOOTER)?|MOTOR\s*CYCLE|SCOOTER|MCWG')
          .firstMatch(upper)
          ?.group(0);

  return Vehicle(
    rcNumber: rc,
    manufacturer: manufacturer,
    brand: canonicalBrand(manufacturer) ?? canonicalBrand(text),
    model: model,
    fuelType: fuel,
    vehicleClass: vehicleClass,
    registrationDate: registrationDate,
    engineNumber: engine,
    chassisNumber: chassis,
  );
}
