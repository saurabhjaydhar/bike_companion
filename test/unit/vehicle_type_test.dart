import 'package:garajo/core/constants/app_constants.dart';
import 'package:garajo/core/services/health_score_service.dart';
import 'package:garajo/core/services/rc_scan_service.dart';
import 'package:garajo/data/models/fuel_log.dart';
import 'package:garajo/data/models/service_record.dart';
import 'package:garajo/data/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';

Vehicle vehicle(VehicleType type, {int odometer = 20000}) => Vehicle(
  id: 'v1',
  name: 'Test',
  brand: 'Brand',
  model: 'Model',
  type: type,
  colourHex: '#1A56DB',
  regNumber: 'MH12DE1234',
  odometerCurrent: odometer,
  odometerOfficial: odometer,
  createdAt: DateTime(2024),
);

ServiceRecord oilChangeAt(int km) => ServiceRecord(
  id: 'oil',
  vehicleId: 'v1',
  date: DateTime.now().subtract(const Duration(days: 30)),
  serviceType: ServiceTypes.oilChange,
  odometer: km,
);

void main() {
  group('vehicleTypeFromRc', () {
    test('reads cars from LMV / motor car classes', () {
      expect(vehicleTypeFromRc(vehicleClass: 'LMV'), VehicleType.car);
      expect(vehicleTypeFromRc(vehicleClass: 'Motor Car (LMV)'), VehicleType.car);
    });

    test('tells scooters from motorcycles', () {
      expect(vehicleTypeFromRc(vehicleClass: 'MCWOG'), VehicleType.scooter);
      expect(
        vehicleTypeFromRc(vehicleClass: 'M-CYCLE/SCOOTER', model: 'ACTIVA 6G'),
        VehicleType.scooter,
      );
      expect(
        vehicleTypeFromRc(vehicleClass: 'M-CYCLE/SCOOTER', model: 'RONIN'),
        VehicleType.bike,
      );
      expect(vehicleTypeFromRc(vehicleClass: 'MCWG'), VehicleType.bike);
    });

    test('is null when the class says nothing', () {
      expect(vehicleTypeFromRc(vehicleClass: null), isNull);
      expect(vehicleTypeFromRc(vehicleClass: 'GOODS CARRIER'), isNull);
    });
  });

  test('car makers are recognised before two-wheeler brands', () {
    expect(canonicalBrand('MARUTI SUZUKI INDIA LTD'), 'Maruti Suzuki');
    expect(canonicalBrand('SUZUKI MOTORCYCLE INDIA PVT LTD'), 'Suzuki');
    expect(canonicalBrand('TATA MOTORS LTD'), 'Tata');
  });

  test('stored type names round-trip; unknown ones are bikes', () {
    for (final t in VehicleType.values) {
      expect(VehicleType.fromName(t.name), t);
    }
    expect(VehicleType.fromName(null), VehicleType.bike);
    expect(Vehicle.fromMap(vehicle(VehicleType.car).toMap()).type,
        VehicleType.car);
  });

  group('health score by vehicle type', () {
    final service = HealthScoreService();

    test('cars have no chain factor and still score out of 100', () {
      final score = service.compute(
        vehicle: vehicle(VehicleType.car),
        services: const [],
        fuelLogs: const [],
      );
      expect(score.factors.map((f) => f.label), isNot(contains('Chain')));
      expect(score.score, inInclusiveRange(0, 100));
    });

    test('6,000 km since an oil change: due on a bike, fine on a car', () {
      Map<String, Object> oil(VehicleType type) {
        final f = service
            .compute(
              vehicle: vehicle(type),
              services: [oilChangeAt(14000)],
              fuelLogs: const [],
            )
            .factors
            .firstWhere((f) => f.label == 'Engine Oil');
        return {'points': f.points, 'max': f.maxPoints};
      }

      expect(oil(VehicleType.bike)['points'], 0); // past 5,000 km
      expect(oil(VehicleType.car)['points'], oil(VehicleType.car)['max']);
    });

    test('a perfect car scores 100', () {
      final now = DateTime.now();
      ServiceRecord done(String type) => ServiceRecord(
            id: type,
            vehicleId: 'v1',
            date: now.subtract(const Duration(days: 10)),
            serviceType: type,
            odometer: 20000,
          );
      final score = service.compute(
        vehicle: vehicle(VehicleType.car).copyWith(
            insuranceExpiry: now.add(const Duration(days: 200))),
        services: [
          for (final t in [
            ServiceTypes.oilChange, ServiceTypes.airFilter,
            ServiceTypes.brakePads, ServiceTypes.tyres, ServiceTypes.battery,
          ])
            done(t),
        ],
        fuelLogs: const [],
      );
      expect(score.score, 100);
    });
  });

  test("computing the score leaves the caller's fuel logs in order", () {
    final logs = [
      FuelLog(id: 'new', vehicleId: 'v1', date: DateTime(2026, 3), odometer: 2),
      FuelLog(id: 'old', vehicleId: 'v1', date: DateTime(2026, 1), odometer: 1),
    ];
    HealthScoreService().compute(
        vehicle: vehicle(VehicleType.bike), services: const [], fuelLogs: logs);
    expect(logs.first.id, 'new');
  });

  test('service menus differ by type', () {
    expect(VehicleType.car.maintenance.serviceTypes,
        containsAll([ServiceTypes.wheelAlignment, ServiceTypes.acService]));
    expect(VehicleType.car.maintenance.serviceTypes,
        isNot(contains(ServiceTypes.chainLube)));
    expect(VehicleType.bike.maintenance.serviceTypes,
        contains(ServiceTypes.chainLube));
    expect(VehicleType.scooter.maintenance.serviceTypes,
        isNot(contains(ServiceTypes.chainClean)));
  });
}
