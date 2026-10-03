import 'package:flutter/material.dart';

import 'vehicle_type.dart';

export 'vehicle_type.dart';

class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final VehicleType type;
  final String? variant;
  final String colourHex;
  final String regNumber;
  final DateTime? purchaseDate;
  final int odometerCurrent;
  final int odometerOfficial;
  final DateTime? insuranceExpiry;
  final DateTime? pucExpiry;

  /// Registration (RC) valid until — "Regn. Validity" on the RC.
  final DateTime? regValidity;
  final DateTime createdAt;

  /// Spending budgets in ₹; null when not set.
  final double? monthlyBudget;
  final double? yearlyBudget;

  // Registration (RC) details — all optional.
  final String? manufacturer;
  final String? fuelType;
  final String? vehicleClass;
  final String? engineNumber;
  final String? chassisNumber;

  const Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    this.type = VehicleType.bike,
    this.variant,
    required this.colourHex,
    required this.regNumber,
    this.purchaseDate,
    required this.odometerCurrent,
    required this.odometerOfficial,
    this.insuranceExpiry,
    this.pucExpiry,
    this.regValidity,
    required this.createdAt,
    this.monthlyBudget,
    this.yearlyBudget,
    this.manufacturer,
    this.fuelType,
    this.vehicleClass,
    this.engineNumber,
    this.chassisNumber,
  });

  Color get colour {
    try {
      final hex = colourHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFF1A56DB);
    }
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) => Vehicle(
        id: map['id'] as String,
        name: map['name'] as String,
        brand: map['brand'] as String,
        model: map['model'] as String,
        type: VehicleType.fromName(map['vehicle_type'] as String?),
        variant: map['variant'] as String?,
        colourHex: map['colour_hex'] as String? ?? '#1A56DB',
        regNumber: map['reg_number'] as String,
        purchaseDate: map['purchase_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['purchase_date'] as int)
            : null,
        odometerCurrent: map['odometer_current'] as int? ?? 0,
        odometerOfficial: map['odometer_official'] as int? ?? 0,
        insuranceExpiry: map['insurance_expiry'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['insurance_expiry'] as int)
            : null,
        pucExpiry: map['puc_expiry'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['puc_expiry'] as int)
            : null,
        regValidity: map['reg_validity'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['reg_validity'] as int)
            : null,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
        monthlyBudget: (map['monthly_budget'] as num?)?.toDouble(),
        yearlyBudget: (map['yearly_budget'] as num?)?.toDouble(),
        manufacturer: map['manufacturer'] as String?,
        fuelType: map['fuel_type'] as String?,
        vehicleClass: map['vehicle_class'] as String?,
        engineNumber: map['engine_number'] as String?,
        chassisNumber: map['chassis_number'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'brand': brand,
        'model': model,
        'vehicle_type': type.name,
        'variant': variant,
        'colour_hex': colourHex,
        'reg_number': regNumber,
        'purchase_date': purchaseDate?.millisecondsSinceEpoch,
        'odometer_current': odometerCurrent,
        'odometer_official': odometerOfficial,
        'insurance_expiry': insuranceExpiry?.millisecondsSinceEpoch,
        'puc_expiry': pucExpiry?.millisecondsSinceEpoch,
        'reg_validity': regValidity?.millisecondsSinceEpoch,
        'created_at': createdAt.millisecondsSinceEpoch,
        'monthly_budget': monthlyBudget,
        'yearly_budget': yearlyBudget,
        'manufacturer': manufacturer,
        'fuel_type': fuelType,
        'vehicle_class': vehicleClass,
        'engine_number': engineNumber,
        'chassis_number': chassisNumber,
      };

  Vehicle copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    VehicleType? type,
    String? variant,
    String? colourHex,
    String? regNumber,
    DateTime? purchaseDate,
    int? odometerCurrent,
    int? odometerOfficial,
    DateTime? insuranceExpiry,
    DateTime? pucExpiry,
    DateTime? regValidity,
    DateTime? createdAt,
    double? monthlyBudget,
    double? yearlyBudget,
    String? manufacturer,
    String? fuelType,
    String? vehicleClass,
    String? engineNumber,
    String? chassisNumber,
  }) =>
      Vehicle(
        id: id ?? this.id,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        type: type ?? this.type,
        variant: variant ?? this.variant,
        colourHex: colourHex ?? this.colourHex,
        regNumber: regNumber ?? this.regNumber,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        odometerCurrent: odometerCurrent ?? this.odometerCurrent,
        odometerOfficial: odometerOfficial ?? this.odometerOfficial,
        insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
        pucExpiry: pucExpiry ?? this.pucExpiry,
        regValidity: regValidity ?? this.regValidity,
        createdAt: createdAt ?? this.createdAt,
        monthlyBudget: monthlyBudget ?? this.monthlyBudget,
        yearlyBudget: yearlyBudget ?? this.yearlyBudget,
        manufacturer: manufacturer ?? this.manufacturer,
        fuelType: fuelType ?? this.fuelType,
        vehicleClass: vehicleClass ?? this.vehicleClass,
        engineNumber: engineNumber ?? this.engineNumber,
        chassisNumber: chassisNumber ?? this.chassisNumber,
      );

  /// Copy with the budgets replaced — null clears them, which [copyWith]
  /// can't do.
  Vehicle withBudgets({double? monthly, double? yearly}) => Vehicle(
        id: id,
        name: name,
        brand: brand,
        model: model,
        type: type,
        variant: variant,
        colourHex: colourHex,
        regNumber: regNumber,
        purchaseDate: purchaseDate,
        odometerCurrent: odometerCurrent,
        odometerOfficial: odometerOfficial,
        insuranceExpiry: insuranceExpiry,
        pucExpiry: pucExpiry,
        regValidity: regValidity,
        createdAt: createdAt,
        monthlyBudget: monthly,
        yearlyBudget: yearly,
        manufacturer: manufacturer,
        fuelType: fuelType,
        vehicleClass: vehicleClass,
        engineNumber: engineNumber,
        chassisNumber: chassisNumber,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Vehicle && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Vehicle($id, $name, $brand $model)';
}
