import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart'
    show compute, debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

import '../../data/models/rc_details.dart';
import '../constants/app_constants.dart';
import 'rc_ocr_layout.dart';

enum RcScanSource { gemini, onDevice }

class RcScanResult {
  final RcDetails? details;
  final RcScanSource source;

  const RcScanResult({required this.details, required this.source});

  /// True when at least the registration number or the make/model was read.
  bool get found =>
      details != null &&
      (details!.rcNumber.isNotEmpty ||
          details!.brand != null ||
          details!.model != null);
}

/// Reads RC (registration certificate) photos into a [Vehicle].
///
/// With [allowCloud], the photo goes to Gemini through Firebase AI Logic —
/// no API key ships in the app. Otherwise, or if that fails (offline, AI Logic
/// not enabled), the text is read on-device with ML Kit and parsed locally.
class RcScanService {
  /// Gemini model used for reading RC photos. Override at build time with
  /// `--dart-define=GEMINI_MODEL=...` when Google retires or replaces it.
  static const geminiModel = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: 'gemini-2.5-flash',
  );

  /// Reads one or more photos of the same RC — e.g. both sides of a smart
  /// card — into a single [Vehicle].
  Future<RcScanResult> scan(
    List<String> imagePaths, {
    required bool allowCloud,
  }) async {
    // Cards are often photographed sideways — turn each photo upright first.
    // Both readers then use the upright photo.
    final pages = [for (final path in imagePaths) await _readUpright(path)];
    RcDetails? local;
    for (final page in pages) {
      final side = parseRcText(page.text);
      local = local == null ? side : mergeRcScans(local, side);
    }

    if (allowCloud) {
      try {
        final details = await _scanWithGemini([for (final p in pages) p.path]);
        if (details != null) {
          _logMissing('Gemini', details);
          // Fill anything Gemini left blank from on-device OCR.
          if (local == null) {
            return RcScanResult(details: details, source: RcScanSource.gemini);
          }
          final merged = mergeRcScans(details, local);
          _logMissing('Gemini + on-device', merged);
          return RcScanResult(details: merged, source: RcScanSource.gemini);
        }
        debugPrint('RC scan: Gemini found no RC, using on-device OCR');
      } catch (e) {
        // Fall through to on-device recognition.
        debugPrint('RC scan: Gemini failed, using on-device OCR: $e');
      }
    }
    if (local != null) _logMissing('On-device', local);
    return RcScanResult(details: local, source: RcScanSource.onDevice);
  }

  static List<String> _missingKeyFields(RcDetails v) => [
    if (v.rcNumber.isEmpty) 'registration number',
    if (v.registrationDate == null) 'registration date',
    if (v.engineNumber == null) 'engine number',
    if (v.chassisNumber == null) 'chassis number',
    if (v.manufacturer == null) 'maker',
    if (v.model == null) 'model',
    if (v.fuelType == null) 'fuel',
  ];

  static void _logMissing(String reader, RcDetails v) {
    final missing = _missingKeyFields(v);
    debugPrint(
      'RC scan: $reader read the RC'
      '${missing.isEmpty ? '' : ', missing: ${missing.join(', ')}'}',
    );
  }

  Future<RcDetails?> _scanWithGemini(List<String> imagePaths) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: geminiModel,
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: _rcSchema,
      ),
    );
    final images = [
      for (final path in imagePaths)
        InlineDataPart(_mimeType(path), await File(path).readAsBytes()),
    ];
    final response = await model.generateContent([
      Content.multi([TextPart(_rcPrompt), ...images]),
    ]);
    final text = response.text
        ?.trim()
        .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
        .replaceFirst(RegExp(r'\s*```$'), '');
    if (text == null || text.isEmpty) return null;
    return rcDetailsFromJson(jsonDecode(text) as Map<String, dynamic>);
  }

  /// Reads [path] with ML Kit and returns an upright copy of the photo with
  /// its text. Cards are often photographed sideways: the direction of the
  /// text lines says how far to turn the photo. If little RC text was read at
  /// all, the other orientations are tried and the best reading is kept.
  Future<({String path, String text})> _readUpright(String path) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      var bestPath = path;
      var best = await _ocr(recognizer, path);
      final turn = uprightRotation(best.angles);
      final angles = [if (turn != 0) turn, ...[90, 270, 180].where((a) => a != turn)];
      for (final angle in angles) {
        final textIsSideways = angle == turn;
        final bestScore = rcTextScore(best.raw);
        if (!textIsSideways && bestScore >= uprightRcScore) break;
        final String rotated;
        try {
          rotated = await _rotatedCopy(path, angle);
        } catch (e) {
          debugPrint('RC scan: could not rotate photo: $e');
          break;
        }
        final ocr = await _ocr(recognizer, rotated);
        final score = rcTextScore(ocr.raw);
        // Upright text lines up labels and values, so prefer it even when
        // ML Kit managed to read the sideways photo about as well.
        if (textIsSideways ? score >= bestScore - 1 : score > bestScore) {
          bestPath = rotated;
          best = ocr;
          debugPrint('RC scan: photo turned $angle° to read it upright');
        } else {
          try {
            await File(rotated).delete();
          } catch (_) {}
        }
      }
      if (kDebugMode) _logRegnLines(best.raw);
      return (path: bestPath, text: rcTextFromWords(best.lines, raw: best.raw));
    } finally {
      await recognizer.close();
    }
  }

  static Future<_Ocr> _ocr(TextRecognizer recognizer, String path) async {
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(path),
      );
      final lines = [
        for (final block in result.blocks) ...block.lines,
      ];
      return (
        raw: result.text,
        lines: [
          for (final line in lines)
            [for (final e in line.elements) OcrWord(e.text, e.boundingBox)],
        ],
        angles: [
          for (final line in lines)
            if (line.text.length >= 3 && line.cornerPoints.length >= 2)
              _baselineAngle(line.cornerPoints),
        ],
      );
    } catch (_) {
      return (raw: '', lines: const <List<OcrWord>>[], angles: const <double>[]);
    }
  }

  /// Direction of a line's baseline (top-left → top-right corner) in degrees.
  static double _baselineAngle(List<math.Point<int>> corners) {
    final (a, b) = (corners[0], corners[1]);
    return math.atan2((b.y - a.y).toDouble(), (b.x - a.x).toDouble()) *
        180 /
        math.pi;
  }

  /// Writes a copy of the photo rotated clockwise by [angle] degrees.
  static Future<String> _rotatedCopy(String path, int angle) async {
    final bytes = await File(path).readAsBytes();
    final rotated = await compute(_rotateJpeg, (bytes, angle));
    final file = File(
      '${Directory.systemTemp.path}/rc_scan_'
      '${DateTime.now().microsecondsSinceEpoch}_$angle.jpg',
    );
    await file.writeAsBytes(rotated);
    return file.path;
  }

  /// Debug builds only: prints the OCR lines around "Regn" labels, to see how
  /// a card that didn't parse was read. Skips the rest, so owner details
  /// aren't logged.
  static void _logRegnLines(String text) {
    final lines = text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      if (!lines[i].toUpperCase().contains('REG')) continue;
      final next = i + 1 < lines.length ? lines[i + 1] : '';
      debugPrint('RC scan OCR: "${lines[i]}" -> next line "$next"');
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
The image(s) should show an Indian vehicle Registration Certificate (RC): a smart card, an RC book page, or a digital RC (mParivahan/DigiLocker).
Images may be rotated; read text in any orientation. When there is more than one image, they are different sides or pages of the same RC — combine them into one answer.
Extract only the vehicle details listed in the schema. Do NOT extract the owner's name, father's name, or address.
Rules:
- Copy values exactly as printed, apart from the formats asked for below. If a field is not clearly visible, return null. Never guess.
- A smart-card RC prints details on both sides. Extract whatever is on the side shown and return null for the rest.
- Labels vary by state and card version, are often abbreviated, and the value may be beside or below its label. Look for:
  - registration_number: "Regn. No.", "Regn. Number", "Registration No.", "Reg. No.". Output without spaces or hyphens, e.g. MH12DE1234 or 22BH1234AA.
  - registration_date: "Date of Regn.", "Regn. Date", "Regd. Date", "Date of Registration". Not "Regn. Validity" (that is the expiry).
  - registration_validity: "Regn. Validity", "Valid Upto", "Regn. Valid Upto" — the date the registration expires.
  - engine_number: "Engine No.", "Engine/Motor Number", "E. No.", "Motor No.".
  - chassis_number: "Chassis No.", "Chassis Number", "Ch. No.", "VIN".
  - manufacturer: "Maker's Name", "Maker", "Mfr", "Manufacturer". The company, e.g. "ROYAL ENFIELD (UNIT OF EICHER MOTORS LTD)", "HONDA MOTORCYCLE AND SCOOTER INDIA PVT LTD".
  - model: "Model Name", "Model name",  "Model", "Maker's Class" / "Maker's Classification". The vehicle's model, e.g. "CLASSIC 350", "ACTIVA 6G", "SPLENDOR PLUS". Never the company name — if only the maker's name is visible, return null for model.
  - fuel_type: "Fuel", "Fuel Used", "Type of Fuel", e.g. Petrol, Diesel, Electric, CNG.
  - vehicle_class: "Vehicle Class", "Class of Vehicle", "Veh. Cl.", e.g. M-Cycle/Scooter, MCWG.
  - colour: "Colour", "Color", e.g. "LTNG BLACK", "RED".
- Common smart-card layout: the front (Form 23) has Regn. No, Date of Regn, Regn. Validity, Chassis No, Engine No, Fuel Used; the back (Form 23A) has Regn. No, Vehicle Class, Maker's Name, Model name, Colour, Month & Yr. of Mfg. "Month & Yr. of Mfg" is the manufacturing date — never use it as registration_date.
- Take each value from beside or below its own label. Labels are sometimes printed as one column with their values in the next, in the same order. Never put the same text in two fields.
- Engine and chassis numbers may be partly masked (e.g. XXXXXX12345) on digital RCs; copy them as printed.
- brand: the consumer brand (e.g. "Royal Enfield", "Honda", "TVS"); manufacturer: the maker's full name as printed.
- Dates are usually printed DD/MM/YYYY or DD-MMM-YYYY; output YYYY-MM-DD.
- Set is_rc to false only if none of the images is part of a vehicle registration certificate. The back of a smart card (maker, model, class, but no "Registration Certificate" heading) still counts.
''';

  static final _rcSchema = Schema.object(
    properties: {
      'is_rc': Schema.boolean(),
      'registration_number': Schema.string(nullable: true),
      'brand': Schema.string(nullable: true),
      'manufacturer': Schema.string(nullable: true),
      'model': Schema.string(nullable: true),
      'fuel_type': Schema.string(nullable: true),
      'vehicle_class': Schema.string(nullable: true),
      'colour': Schema.string(nullable: true),
      'registration_date': Schema.string(nullable: true),
      'registration_validity': Schema.string(nullable: true),
      'engine_number': Schema.string(nullable: true),
      'chassis_number': Schema.string(nullable: true),
    },
  );
}

/// Runs in a background isolate: decodes, applies the EXIF orientation,
/// rotates clockwise and re-encodes as JPEG.
Uint8List _rotateJpeg((Uint8List, int) job) {
  final (bytes, angle) = job;
  final image = img.decodeImage(bytes);
  if (image == null) throw const FormatException('Unreadable image');
  return img.encodeJpg(
    img.copyRotate(img.bakeOrientation(image), angle: angle),
    quality: 90,
  );
}

typedef _Ocr = ({
  String raw,
  List<List<OcrWord>> lines,
  List<double> angles,
});

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
  bool has(String word) =>
      RegExp('\\b${RegExp.escape(word.toUpperCase())}\\b').hasMatch(upper);
  // Car makers first: "MARUTI SUZUKI" is a car, not a Suzuki two-wheeler.
  for (final brand in [...kCarBrands, ...kIndianBrands]) {
    if (brand == 'Other') continue;
    if (has(brand)) return brand;
  }
  if (has('EICHER')) return 'Royal Enfield';
  return null;
}

/// Combines the readings of both sides of an RC card. Fields read from
/// [first] win; [second] only fills the gaps.
RcDetails mergeRcScans(RcDetails first, RcDetails second) {
  final manufacturer = first.manufacturer ?? second.manufacturer;
  return RcDetails(
  rcNumber: first.rcNumber.isNotEmpty ? first.rcNumber : second.rcNumber,
  manufacturer: manufacturer,
  // The maker's name decides the brand — a brand guessed from the other
  // side's text must not override it.
  brand: canonicalBrand(manufacturer) ?? first.brand ?? second.brand,
  model: first.model ?? second.model,
  variant: first.variant ?? second.variant,
  fuelType: first.fuelType ?? second.fuelType,
  registrationDate: first.registrationDate ?? second.registrationDate,
  vehicleClass: first.vehicleClass ?? second.vehicleClass,
  engineNumber: first.engineNumber ?? second.engineNumber,
  chassisNumber: first.chassisNumber ?? second.chassisNumber,
  colour: first.colour ?? second.colour,
  insuranceExpiry: first.insuranceExpiry ?? second.insuranceExpiry,
  regValidity: first.regValidity ?? second.regValidity,
);
}

/// Converts Gemini's structured output into a [Vehicle]. Returns null when
/// the photo wasn't an RC.
RcDetails? rcDetailsFromJson(Map<String, dynamic> json) {
  if (json['is_rc'] == false) return null;
  String? str(String key) {
    final v = json[key]?.toString().trim();
    return (v == null || v.isEmpty || v.toLowerCase() == 'null') ? null : v;
  }

  final (manufacturer, model) = _makerAndModel(
    _withoutLabels(str('manufacturer')),
    _withoutLabels(str('model')),
  );
  final brand =
      canonicalBrand(str('brand')) ??
      canonicalBrand(manufacturer) ??
      str('brand');
  return RcDetails(
    rcNumber: normalizeRegNumber(str('registration_number') ?? ''),
    manufacturer: manufacturer,
    brand: brand,
    model: _withoutBrand(model, brand),
    fuelType: _fuelName(str('fuel_type')),
    vehicleClass: _withoutLabels(str('vehicle_class')),
    colour: _withoutLabels(str('colour')),
    // ISO as asked, or as printed ("23-May-2026") when Gemini copies it.
    registrationDate: _anyDate(str('registration_date')),
    regValidity: _anyDate(str('registration_validity')),
    engineNumber: str('engine_number')?.replaceAll(' ', '').toUpperCase(),
    chassisNumber: str('chassis_number')?.replaceAll(' ', '').toUpperCase(),
  );
}

final _regNumber = RegExp(
  r'\b([A-Z]{2})[\s\-]?(\d{1,2})[\s\-]?([A-Z]{1,3})[\s\-]?(\d{4})\b',
);
final _bharatSeries = RegExp(
  r'\b(\d{2})[\s\-]?BH[\s\-]?(\d{4})[\s\-]?([A-Z]{1,2})\b',
);
final _vin = RegExp(
  r'\b(?=[A-HJ-NPR-Z0-9]*\d)(?=[A-HJ-NPR-Z0-9]*[A-Z])[A-HJ-NPR-Z0-9]{17}\b',
);
final _date = RegExp(
  r'\b(\d{1,2})[\/\-. ](\d{1,2}|[A-Za-z]{3})[\/\-. ](\d{4})\b',
);

// Field labels as printed on RCs (they vary by state and card version).
// Each consumes a trailing "No." / "Number" so the value is what follows.
// No trailing \b: OCR often runs the value into the label ("Regn. NoMH12…").
final _regNoLabel = RegExp(r'\bREG(?:N|D|ISTRATION)?\.?\s*(?:NUMBER|NO)\.?');
final _regDateLabel = RegExp(
  r'DATE\s*OF\s*REG(?:N|ISTRATION)?\b\.?|\bREG(?:N|D|ISTRATION)?\.?\s*(?:DATE|DT)\b\.?',
);
final _regValidityLabel = RegExp(
  r'REG(?:N|ISTRATION)?\.?\s*VALID(?:ITY|\s*UP\s*TO)|\bVALID\s*UP\s*TO\b',
);
// Words in labels whose value is a date — to line up a row of date labels
// with the row of dates below it.
final _dateLabelWord = RegExp(r'\bDATE\b|VALIDITY|\bUP\s*TO\b|\bEXPIRY\b');
final _chassisLabel = RegExp(
  r'(?:CHASSIS|\bCH\.?)\s*(?:NO|NUMBER)?\b\.?|\bVIN\b',
);
final _engineLabel = RegExp(
  r'ENGINE(?:\s*/\s*MOTOR)?\s*(?:NO|NUMBER)?\b\.?|\b(?:ENG|E|MOTOR)\.?\s*(?:NO|NUMBER)\b\.?',
);

// A line that is only a label — including RC labels that aren't parsed, so a
// column of labels can be lined up with the column of values beside it.
final _labelOnly = RegExp(
  r'^\s*(?:'
  r'REG(?:N|D|ISTRATION)?\.?\s*(?:NO|NUMBER|DATE|DT|VALIDITY)'
  r'|DATE\s*OF\s*REG\w*|CHASSIS(?:\s*(?:NO|NUMBER))?|CH\.?\s*NO|VIN'
  r'|ENGINE(?:\s*/\s*MOTOR)?(?:\s*(?:NO|NUMBER))?|E\.?\s*NO'
  r'|MOTOR\s*(?:NO|NUMBER)'
  r"|MAKER'?S?(?:\s*(?:NAME|CLASS\w*))?|MANUFACTURER|MFR|MODEL(?:\s*NAME)?"
  r'|FUEL(?:\s*USED)?|TYPE\s*OF\s*FUEL|VEHICLE\s*CLASS|CLASS\s*OF\s*VEH\w*'
  r'|VEH\.?\s*CL\w*|OWNER(?:\s*NAME)?|OWNER\s*SR\.?\s*NO|ADDRESS'
  r'|SON\s*/\s*DAUGHTER\s*/\s*WIFE\s*OF|S/D/W\s*OF|COLOU?R|BODY\s*TYPE'
  r'|SEATING\s*CAP\w*|UNLADEN\s*W\w*|CUBIC\s*CAP\w*|HORSE\s*POWER'
  r'|WHEEL\s*BASE(?:\s*\(MM\))?|MFG\.?\s*DATE|MONTH\s*&\s*YR\.?\s*OF\s*MFG'
  r'|NO\.?\s*OF\s*CYL\w*|FINANCIER(?:\s*NAME)?|ULW(?:\s*\(KGS\))?'
  r'|SEATING\s*\(IN\s*ALL\)\s*CAPACITY|REGISTERING\s*AUTHORITY'
  r'|EMISSION\s*NORMS|TAX\s*UP\s*TO|INSURANCE\s*UP\s*TO|FITNESS\s*UP\s*TO'
  r')[\s:.\-]*$',
);

String _straightQuotes(String s) =>
    s.replaceAll(RegExp('[\u2018\u2019`\u00B4]'), "'");

/// True for text that is only an RC label, like "Regn. No" or "Maker's Name".
bool isRcLabelLine(String text) =>
    _labelOnly.hasMatch(_straightQuotes(text).toUpperCase());

/// Drops label text that OCR ran into a value, e.g. "Month & Yr.of Mfg TVS
/// RONIN" → "TVS RONIN".
String? _withoutLabels(String? value) {
  if (value == null) return null;
  final words = value.trim().split(RegExp(r'\s+'));
  final kept = [
    for (final run in splitAtLabels(words, (w) => w, isRcLabelLine))
      if (!run.isLabel) ...run.words,
  ].join(' ');
  return kept.isEmpty ? null : kept;
}

/// Text for [parseRcText] from OCR words: label/value pairs rebuilt from word
/// positions first, then OCR's own text ([raw]) for anything else.
String rcTextFromWords(List<List<OcrWord>> lines, {required String raw}) =>
    '${layoutRcText(lines, isRcLabelLine)}\n$raw';

String? _knownFuel(String upper) {
  for (final f in const ['ELECTRIC', 'PETROL', 'DIESEL', 'CNG', 'LPG']) {
    if (upper.contains(f)) {
      return f == 'CNG' || f == 'LPG'
          ? f
          : '${f[0]}${f.substring(1).toLowerCase()}';
    }
  }
  return null;
}

/// "PETROL(E20)" → "Petrol"; unknown fuels are kept as printed.
String? _fuelName(String? s) =>
    s == null ? null : _knownFuel(s.toUpperCase()) ?? s;

/// "TVS RONIN" → "RONIN" when the brand is TVS, so the vehicle isn't named
/// "TVS TVS RONIN".
String? _withoutBrand(String? model, String? brand) {
  if (model == null || brand == null) return model;
  final stripped = model
      .replaceFirst(RegExp('^${RegExp.escape(brand)}\\b', caseSensitive: false), '')
      .trim();
  return stripped.isEmpty ? model : stripped;
}

// Words printed on every RC. How many of them OCR finds tells whether the
// photo was read the right way up.
final _rcWords = RegExp(
  r'REGN|REGISTRATION|CHASSIS|ENGINE|OWNER|ADDRESS|FUEL|EMISSION|MAKER'
  r'|MODEL|COLOU?R|BODY\s*TYPE|SEATING|WHEEL\s*BASE|CUBIC|CYLINDER'
  r'|FINANCIER|VEHICLE\s*CLASS|VALIDITY|TRANSPORT|TAX\s*UP',
);

/// A [rcTextScore] at or above this means the text was read upright.
const uprightRcScore = 4;

/// How much RC-like text OCR found: distinct RC words, plus a bonus for a
/// number plate. Sideways or upside-down photos score near zero.
int rcTextScore(String text) {
  final upper = text.toUpperCase();
  final words = {
    for (final m in _rcWords.allMatches(upper))
      m[0]!.replaceAll(RegExp(r'\s'), ''),
  };
  return words.length + (_regNumber.hasMatch(upper) ? 2 : 0);
}

final _companyWords = RegExp(
  r'\b(?:LTD|LIMITED|PVT|PRIVATE|CORP|CORPORATION|COMPANY|UNIT OF)\b',
);

/// True for a maker's name ("HONDA MOTORCYCLE AND SCOOTER INDIA PVT LTD",
/// "HONDA") rather than a model ("ACTIVA 6G").
bool _looksLikeCompany(String s) {
  final upper = s.toUpperCase().trim();
  final brand = canonicalBrand(s);
  return _companyWords.hasMatch(upper) ||
      (brand != null && upper == brand.toUpperCase());
}

/// Fixes maker/model mix-ups — the "Maker's Name" and "Model Name" labels
/// sit side by side on RCs. A company name read as the model is swapped back
/// when the maker field holds the model, and dropped otherwise.
(String?, String?) _makerAndModel(String? maker, String? model) {
  if (model == null || !_looksLikeCompany(model)) {
    final same =
        model != null &&
        maker != null &&
        model.toUpperCase().trim() == maker.toUpperCase().trim();
    return (maker, same ? null : model);
  }
  if (maker != null &&
      !_looksLikeCompany(maker) &&
      canonicalBrand(maker) == null) {
    return (model, maker);
  }
  return (maker ?? model, null);
}

// A number plate at the start of a value, with spaces and punctuation
// removed. Digit groups tolerate OCR reading 0/1/5/8 as O/I/S/B.
final _plateAtStart = RegExp(
  r'^([A-Z]{2})([0-9OI]{1,2})([A-Z]{1,3})([0-9OISB]{4})',
);
final _bharatAtStart = RegExp(r'^(\d{2})BH(\d{4})([A-Z]{1,2})');

String _ocrDigits(String s) => s
    .replaceAll('O', '0')
    .replaceAll('I', '1')
    .replaceAll('S', '5')
    .replaceAll('B', '8');

/// Registration number from the text right after a "Regn. No." label.
String? _labelledRegNumber(String value) {
  final c = value.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  final bh = _bharatAtStart.firstMatch(c);
  if (bh != null) return '${bh[1]}BH${bh[2]}${bh[3]}';
  final m = _plateAtStart.firstMatch(c);
  if (m == null) return null;
  return '${m[1]}${_ocrDigits(m[2]!).padLeft(2, '0')}${m[3]}'
      '${_ocrDigits(m[4]!)}';
}

const _months = {
  'JAN': 1,
  'FEB': 2,
  'MAR': 3,
  'APR': 4,
  'MAY': 5,
  'JUN': 6,
  'JUL': 7,
  'AUG': 8,
  'SEP': 9,
  'OCT': 10,
  'NOV': 11,
  'DEC': 12,
};

/// ISO ("2026-05-23") or as printed on the card ("23-May-2026").
DateTime? _anyDate(String? s) =>
    s == null ? null : DateTime.tryParse(s) ?? _parseDate(s);

DateTime? _parseDate(String text) {
  final m = _date.firstMatch(text);
  if (m == null) return null;
  final day = int.parse(m.group(1)!);
  final rawMonth = m.group(2)!;
  final month = int.tryParse(rawMonth) ?? _months[rawMonth.toUpperCase()];
  final year = int.parse(m.group(3)!);
  if (month == null || month < 1 || month > 12 || day < 1 || day > 31) {
    return null;
  }
  return DateTime(year, month, day);
}

/// Best-effort parser for OCR text from an RC. Labels differ between states
/// and card versions, so each field is looked up by a few label variants and
/// taken either from the same line (after ':') or from the next line.
RcDetails parseRcText(String text) {
  // OCR often reads the apostrophe in "Maker's" as a curly one.
  text = _straightQuotes(text);
  final lines = text
      .split('\n')
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();
  final upper = text.toUpperCase();

  bool isLabelLine(String line) => isRcLabelLine(line);

  /// Where the value of the label on line [i] can be: the rest of that line,
  /// else the line below. When several labels are printed as one column and
  /// their values as another, the value is at the same position after the
  /// run of labels.
  List<String> candidates(int i, int labelEnd) {
    final rest = lines[i]
        .substring(labelEnd)
        .replaceFirst(RegExp(r'^[\s:.\-]+'), '')
        .trim();
    var start = i, end = i;
    if (isLabelLine(lines[i])) {
      while (start > 0 && isLabelLine(lines[start - 1])) {
        start--;
      }
      while (end + 1 < lines.length && isLabelLine(lines[end + 1])) {
        end++;
      }
    }
    final below = end + 1 + (i - start);
    return [if (rest.isNotEmpty) rest, if (below < lines.length) lines[below]];
  }

  String? valueAfter(RegExp label) {
    for (var i = 0; i < lines.length; i++) {
      final m = label.firstMatch(lines[i].toUpperCase());
      if (m == null) continue;
      for (final value in candidates(i, m.end)) {
        if (!isLabelLine(value)) return value;
      }
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

  /// First value after [label] that [parse] accepts, looked up like
  /// [valueAfter].
  T? parsedAfter<T>(RegExp label, T? Function(String) parse) {
    for (var i = 0; i < lines.length; i++) {
      final m = label.firstMatch(lines[i].toUpperCase());
      if (m == null) continue;
      for (final value in candidates(i, m.end)) {
        final parsed = parse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  String? regNumberIn(String s) {
    final t = s.toUpperCase();
    final bh = _bharatSeries.firstMatch(t);
    if (bh != null) return '${bh.group(1)}BH${bh.group(2)}${bh.group(3)}';
    final reg = _regNumber.firstMatch(t);
    if (reg == null) return null;
    return '${reg.group(1)}${reg.group(2)!.padLeft(2, '0')}'
        '${reg.group(3)}${reg.group(4)}';
  }

  // Registration number — "Regn. No.", "Registration Number"; else the
  // first number-plate pattern anywhere.
  final rc =
      parsedAfter(_regNoLabel, _labelledRegNumber) ?? regNumberIn(text) ?? '';

  // Chassis / engine numbers
  final chassis =
      parsedAfter(_chassisLabel, (s) => token(s, minLength: 10)) ??
      _vin.firstMatch(upper)?.group(0);
  final engine = parsedAfter(_engineLabel, token);

  /// Date after [label]. When several date labels share a row ("Date of
  /// Regn  Regn.Validity") and their dates share the row below, takes the
  /// date in the same position.
  DateTime? dateAfter(RegExp label) {
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].toUpperCase();
      final m = label.firstMatch(line);
      if (m == null) continue;
      final values = candidates(i, m.end);
      final inline = values.isEmpty ? null : _parseDate(values.first);
      if (inline != null) return inline;
      if (values.isEmpty) continue;
      final position =
          _dateLabelWord.allMatches(line.substring(0, m.start)).length;
      final dates = _date.allMatches(values.last).toList();
      if (position < dates.length) return _parseDate(dates[position][0]!);
    }
    return null;
  }

  // Dates
  final registrationDate = dateAfter(_regDateLabel);
  final regValidity = dateAfter(_regValidityLabel);

  // Maker / model. "Maker's Class(ification)" is the model on older RCs.
  final (manufacturer, model) = _makerAndModel(
    _withoutLabels(
      valueAfter(
        RegExp(
          r"MAKER'?S?\s*NAME|MANUFACTURER|\bMFR\b|\bMAKER\b(?!\s*'?S?\s*CLASS)",
        ),
      ),
    ),
    _withoutLabels(
      valueAfter(RegExp(r"MODEL\s*NAME|MAKER'?S?\s*CLASS\w*|\bMODEL\b")),
    ),
  );

  // Fuel — from its label, else any fuel named on the card.
  final fuel =
      _fuelName(valueAfter(RegExp(r'FUEL(?:\s*USED)?|TYPE\s*OF\s*FUEL'))) ??
      _knownFuel(upper);

  // Vehicle class
  final vehicleClass =
      _withoutLabels(
        valueAfter(RegExp(r'VEHICLE\s*CLASS|VEH\.?\s*CLASS|CLASS\s*OF\s*VEH')),
      ) ??
      RegExp(
        r'M[\-\s]?CYCLE(/SCOOTER)?|MOTOR\s*CYCLE|SCOOTER|MCWG',
      ).firstMatch(upper)?.group(0);

  final brand = canonicalBrand(manufacturer) ?? canonicalBrand(text);
  return RcDetails(
    rcNumber: rc,
    manufacturer: manufacturer,
    brand: brand,
    model: _withoutBrand(model, brand),
    fuelType: fuel,
    vehicleClass: vehicleClass,
    colour: _withoutLabels(valueAfter(RegExp(r'\bCOLOU?R\b'))),
    registrationDate: registrationDate,
    regValidity: regValidity,
    engineNumber: engine,
    chassisNumber: chassis,
  );
}
