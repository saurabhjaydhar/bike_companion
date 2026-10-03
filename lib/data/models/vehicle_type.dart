import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

enum VehicleType {
  bike,
  scooter,
  car;

  /// Stored name back to a type; unknown or missing names are bikes (the
  /// only kind before car support).
  static VehicleType fromName(String? name) =>
      values.where((t) => t.name == name).firstOrNull ?? bike;

  IconData get icon => switch (this) {
    bike => Icons.two_wheeler_rounded,
    scooter => Icons.moped_rounded,
    car => Icons.directions_car_rounded,
  };

  MaintenanceProfile get maintenance => switch (this) {
    bike => MaintenanceProfile.bike,
    scooter => MaintenanceProfile.scooter,
    car => MaintenanceProfile.car,
  };
}

/// When an item is still fine ([good]) and when it's fully due ([due]) — in
/// km or years. The health score falls linearly between the two.
typedef Interval = ({double good, double due});

/// Service intervals and service items, which differ by vehicle type.
class MaintenanceProfile {
  final Interval oilKm;

  /// Null when the vehicle has no chain (scooters, cars).
  final Interval? chainKm;
  final Interval airFilterKm;
  final Interval brakePadsKm;
  final Interval tyreYears;
  final Interval batteryYears;

  /// Service types offered when logging a service, in menu order.
  final List<String> serviceTypes;

  /// Service types listed with their status on the service screen.
  final List<String> trackedTypes;

  const MaintenanceProfile({
    required this.oilKm,
    required this.chainKm,
    required this.airFilterKm,
    required this.brakePadsKm,
    required this.tyreYears,
    required this.batteryYears,
    required this.serviceTypes,
    required this.trackedTypes,
  });

  static const bike = MaintenanceProfile(
    oilKm: (good: 3000, due: 5000),
    chainKm: (good: 800, due: 1500),
    airFilterKm: (good: 8000, due: 12000),
    brakePadsKm: (good: 8000, due: 15000),
    tyreYears: (good: 2, due: 4),
    batteryYears: (good: 2, due: 4),
    serviceTypes: [
      ServiceTypes.oilChange, ServiceTypes.oilFilter, ServiceTypes.airFilter,
      ServiceTypes.chainClean, ServiceTypes.chainLube, ServiceTypes.brakePads,
      ServiceTypes.tyres, ServiceTypes.battery, ServiceTypes.coolant,
      ServiceTypes.other,
    ],
    trackedTypes: [
      ServiceTypes.oilChange, ServiceTypes.airFilter, ServiceTypes.chainClean,
      ServiceTypes.brakePads, ServiceTypes.tyres, ServiceTypes.battery,
      ServiceTypes.coolant, ServiceTypes.other,
    ],
  );

  static const scooter = MaintenanceProfile(
    oilKm: (good: 2500, due: 4000),
    chainKm: null,
    airFilterKm: (good: 6000, due: 10000),
    brakePadsKm: (good: 6000, due: 12000),
    tyreYears: (good: 2, due: 4),
    batteryYears: (good: 2, due: 4),
    serviceTypes: [
      ServiceTypes.oilChange, ServiceTypes.oilFilter, ServiceTypes.airFilter,
      ServiceTypes.brakePads, ServiceTypes.tyres, ServiceTypes.battery,
      ServiceTypes.other,
    ],
    trackedTypes: [
      ServiceTypes.oilChange, ServiceTypes.airFilter, ServiceTypes.brakePads,
      ServiceTypes.tyres, ServiceTypes.battery, ServiceTypes.other,
    ],
  );

  static const car = MaintenanceProfile(
    oilKm: (good: 10000, due: 15000),
    chainKm: null,
    airFilterKm: (good: 15000, due: 25000),
    brakePadsKm: (good: 25000, due: 40000),
    tyreYears: (good: 4, due: 6),
    batteryYears: (good: 3, due: 5),
    serviceTypes: [
      ServiceTypes.oilChange, ServiceTypes.oilFilter, ServiceTypes.airFilter,
      ServiceTypes.brakePads, ServiceTypes.tyres, ServiceTypes.battery,
      ServiceTypes.coolant, ServiceTypes.wheelAlignment,
      ServiceTypes.acService, ServiceTypes.wipers, ServiceTypes.other,
    ],
    trackedTypes: [
      ServiceTypes.oilChange, ServiceTypes.airFilter, ServiceTypes.brakePads,
      ServiceTypes.tyres, ServiceTypes.battery, ServiceTypes.coolant,
      ServiceTypes.wheelAlignment, ServiceTypes.acService, ServiceTypes.other,
    ],
  );
}

// Scooter models, to tell scooters from motorcycles: RCs list both as
// "M-CYCLE/SCOOTER".
final _scooterModels = RegExp(
  r'\b(?:ACTIVA|JUPITER|ACCESS|NTORQ|DIO|FASCINO|RAY\s*Z?R?|MAESTRO|'
  r'PLEASURE|DESTINI|BURGMAN|AVENIS|CHETAK|IQUBE|ATHER|VESPA|AEROX|'
  r'GRAZIA|ZEST|PEP|AVIATOR|XOOM|ROMA|S1\s*(?:PRO|AIR|X)?|RIZTA)\b',
);

/// Vehicle type from the RC's vehicle class and model, or null when unclear.
/// "LMV" / "Motor Car" are cars; "MCWOG" (motorcycle without gear) and
/// known scooter models are scooters; other two-wheeler classes are bikes.
VehicleType? vehicleTypeFromRc({String? vehicleClass, String? model}) {
  final c = (vehicleClass ?? '').toUpperCase();
  final m = (model ?? '').toUpperCase();
  if (RegExp(r'\bLMV\b|MOTOR\s*CAR|LIGHT\s*MOTOR\s*VEHICLE|\bCAR\b').hasMatch(c)) {
    return VehicleType.car;
  }
  final twoWheeler =
      RegExp(r'CYCLE|SCOOTER|MCW|2WN|TWO\s*WHEELER').hasMatch(c);
  if (RegExp(r'MCWOG|MOPED').hasMatch(c) || _scooterModels.hasMatch(m)) {
    return VehicleType.scooter;
  }
  if (twoWheeler) return VehicleType.bike;
  return null;
}
