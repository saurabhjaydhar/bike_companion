class Vehicle {
  final String rcNumber;
  final String? manufacturer;
  final String? brand;
  final String? model;
  final String? variant;
  final String? fuelType;
  final DateTime? registrationDate;
  final String? vehicleClass;
  final String? engineNumber;
  final String? chassisNumber;
  final DateTime? insuranceExpiry;

  const Vehicle({
    required this.rcNumber,
    this.manufacturer,
    this.brand,
    this.model,
    this.variant,
    this.fuelType,
    this.registrationDate,
    this.vehicleClass,
    this.engineNumber,
    this.chassisNumber,
    this.insuranceExpiry,
  });

  factory Vehicle.fromApiResponse(Map<String, dynamic> json, String rcNumber) {
    String? pick(String snake, String camel) {
      final v = json[snake] ?? json[camel];
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isNotEmpty ? s : null;
    }

    DateTime? parseDate(String snake, String camel) {
      final raw = json[snake] ?? json[camel];
      if (raw == null) return null;
      try {
        return DateTime.parse(raw.toString());
      } catch (_) {
        return null;
      }
    }

    return Vehicle(
      rcNumber: rcNumber,
      manufacturer: pick('manufacturer', 'manufacturer'),
      brand: pick('brand', 'brand') ?? pick('make', 'make'),
      model: pick('model', 'model'),
      variant: pick('variant', 'variant'),
      fuelType: pick('fuel_type', 'fuelType'),
      registrationDate: parseDate('registration_date', 'registrationDate'),
      vehicleClass: pick('vehicle_class', 'vehicleClass'),
      engineNumber: pick('engine_number', 'engineNumber'),
      chassisNumber: pick('chassis_number', 'chassisNumber'),
      insuranceExpiry: parseDate('insurance_expiry', 'insuranceExpiry'),
    );
  }

  Vehicle copyWith({
    String? rcNumber,
    String? manufacturer,
    String? brand,
    String? model,
    String? variant,
    String? fuelType,
    DateTime? registrationDate,
    String? vehicleClass,
    String? engineNumber,
    String? chassisNumber,
    DateTime? insuranceExpiry,
  }) =>
      Vehicle(
        rcNumber: rcNumber ?? this.rcNumber,
        manufacturer: manufacturer ?? this.manufacturer,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        variant: variant ?? this.variant,
        fuelType: fuelType ?? this.fuelType,
        registrationDate: registrationDate ?? this.registrationDate,
        vehicleClass: vehicleClass ?? this.vehicleClass,
        engineNumber: engineNumber ?? this.engineNumber,
        chassisNumber: chassisNumber ?? this.chassisNumber,
        insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      );

  Map<String, dynamic> toMap() => {
        'rc_number': rcNumber,
        'manufacturer': manufacturer,
        'brand': brand,
        'model': model,
        'variant': variant,
        'fuel_type': fuelType,
        'registration_date': registrationDate?.millisecondsSinceEpoch,
        'vehicle_class': vehicleClass,
        'engine_number': engineNumber,
        'chassis_number': chassisNumber,
        'insurance_expiry': insuranceExpiry?.millisecondsSinceEpoch,
      };

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    DateTime? ms(dynamic v) =>
        v != null ? DateTime.fromMillisecondsSinceEpoch(v as int) : null;

    return Vehicle(
      rcNumber: map['rc_number'] as String,
      manufacturer: map['manufacturer'] as String?,
      brand: map['brand'] as String?,
      model: map['model'] as String?,
      variant: map['variant'] as String?,
      fuelType: map['fuel_type'] as String?,
      registrationDate: ms(map['registration_date']),
      vehicleClass: map['vehicle_class'] as String?,
      engineNumber: map['engine_number'] as String?,
      chassisNumber: map['chassis_number'] as String?,
      insuranceExpiry: ms(map['insurance_expiry']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Vehicle &&
          runtimeType == other.runtimeType &&
          rcNumber == other.rcNumber;

  @override
  int get hashCode => rcNumber.hashCode;
}

final _regNumberPattern = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{1,4}$');
final _bharatSeriesPattern = RegExp(r'^[0-9]{2}BH[0-9]{4}[A-Z]{1,2}$');

/// Indian registration number, already normalized (no spaces, upper case).
/// Accepts state series (MH12DE1234) and Bharat series (22BH1234AA).
bool isValidRegNumber(String normalized) =>
    _regNumberPattern.hasMatch(normalized) ||
    _bharatSeriesPattern.hasMatch(normalized);

/// How the vehicle details form was pre-filled.
enum VehiclePrefill { manual, lookup, scan }
