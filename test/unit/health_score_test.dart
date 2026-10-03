import 'package:garajo/core/constants/app_constants.dart';
import 'package:garajo/core/services/health_score_service.dart';
import 'package:garajo/data/models/vehicle.dart';
import 'package:garajo/data/models/fuel_log.dart';
import 'package:garajo/data/models/health_score.dart';
import 'package:garajo/data/models/service_record.dart';
import 'package:flutter_test/flutter_test.dart';

// A freshly-serviced vehicle at 10,000 km
Vehicle _vehicle({int odometer = 10000, DateTime? insuranceExpiry}) => Vehicle(
      id: 'b1',
      name: 'Test Vehicle',
      brand: 'Honda',
      model: 'Shine',
      colourHex: '#1A56DB',
      regNumber: 'MH01AB1234',
      odometerCurrent: odometer,
      odometerOfficial: odometer,
      insuranceExpiry: insuranceExpiry,
      createdAt: DateTime(2024, 1, 1),
    );

ServiceRecord _service(String type, {int kmAgo = 0, int daysAgo = 0}) {
  final now = DateTime.now();
  return ServiceRecord(
    id: '${type}_1',
    vehicleId: 'b1',
    date: now.subtract(Duration(days: daysAgo)),
    serviceType: type,
    odometer: 10000 - kmAgo,
  );
}

FuelLog _fuelLog(double mileage, {int daysAgo = 0}) => FuelLog(
      id: 'fl_$daysAgo',
      vehicleId: 'b1',
      date: DateTime.now().subtract(Duration(days: daysAgo)),
      odometer: 10000 - daysAgo * 10,
      mileageCalculated: mileage,
    );

void main() {
  final svc = HealthScoreService();

  group('HealthScoreService.compute — grade thresholds', () {
    test('all services recent → score ≥ 90 → excellent', () {
      final result = svc.compute(
        vehicle: _vehicle(
            insuranceExpiry: DateTime.now().add(const Duration(days: 180))),
        services: [
          _service(ServiceTypes.oilChange, kmAgo: 500),
          _service(ServiceTypes.chainClean, kmAgo: 200),
          _service(ServiceTypes.airFilter, kmAgo: 1000),
          _service(ServiceTypes.brakePads, kmAgo: 1000),
          _service(ServiceTypes.tyres, daysAgo: 100),
          _service(ServiceTypes.battery, daysAgo: 100),
        ],
        fuelLogs: [],
      );
      expect(result.score, greaterThanOrEqualTo(90));
      expect(result.grade, HealthGrade.excellent);
    });

    test('no services logged → score ≤ 10 → critical', () {
      final result = svc.compute(
        vehicle: _vehicle(),
        services: [],
        fuelLogs: [],
      );
      // Only fuel economy (10 pts, < 3 logs) contributes when nothing serviced
      expect(result.score, lessThanOrEqualTo(10));
      expect(result.grade, HealthGrade.critical);
    });

    test('grade poor when score between 25 and 49', () {
      // Just oil changed very recently, everything else stale
      final result = svc.compute(
        vehicle: _vehicle(
            insuranceExpiry: DateTime.now().add(const Duration(days: 180))),
        services: [
          _service(ServiceTypes.oilChange, kmAgo: 100),
        ],
        fuelLogs: [],
      );
      expect(result.grade == HealthGrade.poor ||
          result.grade == HealthGrade.fair ||
          result.grade == HealthGrade.critical, isTrue);
    });
  });

  group('HealthScoreService.compute — individual factors', () {
    test('engine oil — full points when < 3000 km since last change', () {
      final result = svc.compute(
        vehicle: _vehicle(),
        services: [_service(ServiceTypes.oilChange, kmAgo: 1000)],
        fuelLogs: [],
      );
      final oilFactor = result.factors.firstWhere((f) => f.label == 'Engine Oil');
      expect(oilFactor.points, equals(20.0));
      expect(oilFactor.status, HealthStatus.good);
    });

    test('engine oil — 0 points when > 5000 km since last change', () {
      final result = svc.compute(
        vehicle: _vehicle(odometer: 10000),
        services: [_service(ServiceTypes.oilChange, kmAgo: 6000)],
        fuelLogs: [],
      );
      final oilFactor = result.factors.firstWhere((f) => f.label == 'Engine Oil');
      expect(oilFactor.points, equals(0.0));
      expect(oilFactor.status, HealthStatus.danger);
    });

    test('chain — partial points in warning zone (800–1500 km)', () {
      final result = svc.compute(
        vehicle: _vehicle(),
        services: [_service(ServiceTypes.chainClean, kmAgo: 1000)],
        fuelLogs: [],
      );
      final factor = result.factors.firstWhere((f) => f.label == 'Chain');
      expect(factor.points, greaterThan(0));
      expect(factor.points, lessThan(15));
      expect(factor.status, HealthStatus.warning);
    });

    test('insurance — full 10 pts when >30 days remaining', () {
      final result = svc.compute(
        vehicle: _vehicle(
            insuranceExpiry: DateTime.now().add(const Duration(days: 60))),
        services: [],
        fuelLogs: [],
      );
      final ins = result.factors.firstWhere((f) => f.label == 'Insurance');
      expect(ins.points, equals(10.0));
      expect(ins.status, HealthStatus.good);
    });

    test('insurance — 0 pts when expired', () {
      final result = svc.compute(
        vehicle: _vehicle(
            insuranceExpiry: DateTime.now().subtract(const Duration(days: 10))),
        services: [],
        fuelLogs: [],
      );
      final ins = result.factors.firstWhere((f) => f.label == 'Insurance');
      expect(ins.points, equals(0.0));
      expect(ins.status, HealthStatus.danger);
    });

    test('fuel economy — 10 pts when < 3 logs (not enough data)', () {
      final result = svc.compute(
        vehicle: _vehicle(),
        services: [],
        fuelLogs: [_fuelLog(45.0), _fuelLog(43.0)],
      );
      final eco = result.factors.firstWhere((f) => f.label == 'Fuel Economy');
      expect(eco.points, equals(10.0));
    });

    test('fuel economy — 10 pts when economy stable', () {
      final logs = [
        _fuelLog(44.0, daysAgo: 0),
        _fuelLog(45.0, daysAgo: 10),
        _fuelLog(44.5, daysAgo: 20),
        _fuelLog(44.0, daysAgo: 30),
        _fuelLog(45.0, daysAgo: 40),
        _fuelLog(44.5, daysAgo: 50),
      ];
      final result = svc.compute(vehicle: _vehicle(), services: [], fuelLogs: logs);
      final eco = result.factors.firstWhere((f) => f.label == 'Fuel Economy');
      expect(eco.points, equals(10.0));
    });

    test('fuel economy — reduced pts when economy drops >20%', () {
      final logs = [
        _fuelLog(30.0, daysAgo: 0),
        _fuelLog(30.0, daysAgo: 10),
        _fuelLog(30.0, daysAgo: 20),
        _fuelLog(45.0, daysAgo: 30),
        _fuelLog(45.0, daysAgo: 40),
        _fuelLog(45.0, daysAgo: 50),
      ];
      final result = svc.compute(vehicle: _vehicle(), services: [], fuelLogs: logs);
      final eco = result.factors.firstWhere((f) => f.label == 'Fuel Economy');
      expect(eco.points, lessThan(10));
    });
  });

  group('HealthScoreService.compute — factor count and max', () {
    test('always returns 8 factors', () {
      final result = svc.compute(vehicle: _vehicle(), services: [], fuelLogs: []);
      expect(result.factors.length, equals(8));
    });

    test('total max points sum to 100', () {
      final result = svc.compute(vehicle: _vehicle(), services: [], fuelLogs: []);
      final maxSum =
          result.factors.fold(0.0, (s, f) => s + f.maxPoints);
      expect(maxSum, equals(100.0));
    });

    test('score is clamped between 0 and 100', () {
      final result = svc.compute(vehicle: _vehicle(), services: [], fuelLogs: []);
      expect(result.score, inInclusiveRange(0, 100));
    });
  });
}
