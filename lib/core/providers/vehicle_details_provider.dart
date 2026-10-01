import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/vehicle.dart';

class VehicleDetailsState {
  final String manufacturer;
  final String brand;
  final String model;
  final String variant;
  final String fuelType;
  final String vehicleClass;
  final String engineNumber;
  final String chassisNumber;
  final DateTime? registrationDate;
  final DateTime? insuranceExpiry;

  const VehicleDetailsState({
    this.manufacturer = '',
    this.brand = '',
    this.model = '',
    this.variant = '',
    this.fuelType = '',
    this.vehicleClass = '',
    this.engineNumber = '',
    this.chassisNumber = '',
    this.registrationDate,
    this.insuranceExpiry,
  });

  factory VehicleDetailsState.fromVehicle(Vehicle v) => VehicleDetailsState(
        manufacturer: v.manufacturer ?? '',
        brand: v.brand ?? '',
        model: v.model ?? '',
        variant: v.variant ?? '',
        fuelType: v.fuelType ?? '',
        vehicleClass: v.vehicleClass ?? '',
        engineNumber: v.engineNumber ?? '',
        chassisNumber: v.chassisNumber ?? '',
        registrationDate: v.registrationDate,
        insuranceExpiry: v.insuranceExpiry,
      );

  VehicleDetailsState copyWith({
    String? manufacturer,
    String? brand,
    String? model,
    String? variant,
    String? fuelType,
    String? vehicleClass,
    String? engineNumber,
    String? chassisNumber,
    DateTime? registrationDate,
    DateTime? insuranceExpiry,
  }) =>
      VehicleDetailsState(
        manufacturer: manufacturer ?? this.manufacturer,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        variant: variant ?? this.variant,
        fuelType: fuelType ?? this.fuelType,
        vehicleClass: vehicleClass ?? this.vehicleClass,
        engineNumber: engineNumber ?? this.engineNumber,
        chassisNumber: chassisNumber ?? this.chassisNumber,
        registrationDate: registrationDate ?? this.registrationDate,
        insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      );
}

class VehicleDetailsNotifier extends StateNotifier<VehicleDetailsState> {
  VehicleDetailsNotifier(Vehicle vehicle)
      : super(VehicleDetailsState.fromVehicle(vehicle));

  void updateManufacturer(String v) =>
      state = state.copyWith(manufacturer: v);
  void updateBrand(String v) => state = state.copyWith(brand: v);
  void updateModel(String v) => state = state.copyWith(model: v);
  void updateVariant(String v) => state = state.copyWith(variant: v);
  void updateFuelType(String v) => state = state.copyWith(fuelType: v);
  void updateVehicleClass(String v) =>
      state = state.copyWith(vehicleClass: v);
  void updateEngineNumber(String v) =>
      state = state.copyWith(engineNumber: v);
  void updateChassisNumber(String v) =>
      state = state.copyWith(chassisNumber: v);

  void setRegistrationDate(DateTime? d) => state = VehicleDetailsState(
        manufacturer: state.manufacturer,
        brand: state.brand,
        model: state.model,
        variant: state.variant,
        fuelType: state.fuelType,
        vehicleClass: state.vehicleClass,
        engineNumber: state.engineNumber,
        chassisNumber: state.chassisNumber,
        registrationDate: d,
        insuranceExpiry: state.insuranceExpiry,
      );

  void setInsuranceExpiry(DateTime? d) => state = VehicleDetailsState(
        manufacturer: state.manufacturer,
        brand: state.brand,
        model: state.model,
        variant: state.variant,
        fuelType: state.fuelType,
        vehicleClass: state.vehicleClass,
        engineNumber: state.engineNumber,
        chassisNumber: state.chassisNumber,
        registrationDate: state.registrationDate,
        insuranceExpiry: d,
      );
}

final vehicleDetailsProvider = StateNotifierProvider.autoDispose
    .family<VehicleDetailsNotifier, VehicleDetailsState, Vehicle>(
  (ref, vehicle) => VehicleDetailsNotifier(vehicle),
);
