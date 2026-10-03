import '../../data/models/vehicle.dart';
import '../../data/models/fuel_log.dart';
import '../../data/models/health_score.dart';
import '../../data/models/service_record.dart';
import '../../l10n/app_localizations.dart';
import '../constants/app_constants.dart';

class HealthScoreService {
  HealthScore compute({
    required Vehicle vehicle,
    required List<ServiceRecord> services,
    required List<FuelLog> fuelLogs,
  }) {
    final now = DateTime.now();
    final factors = <HealthFactor>[];

    ServiceRecord? lastOf(String type) {
      final filtered = services
          .where((s) => s.serviceType == type)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return filtered.isEmpty ? null : filtered.first;
    }

    // Linear interpolation: full points up to `full`, drops to 0 at `zero`.
    double linearScore({
      required double current,
      required double full,
      required double zero,
      required double maxPts,
    }) {
      if (current <= full) return maxPts;
      if (current >= zero) return 0;
      return maxPts * (1 - (current - full) / (zero - full));
    }

    HealthStatus statusFor(double pts, double max) {
      final ratio = max > 0 ? pts / max : 0;
      if (ratio >= 0.75) return HealthStatus.good;
      if (ratio >= 0.4) return HealthStatus.warning;
      return HealthStatus.danger;
    }

    // 1. Engine oil — 20 pts
    final lastOil = lastOf(ServiceTypes.oilChange);
    final kmOil = lastOil != null
        ? (vehicle.odometerCurrent - lastOil.odometer).toDouble()
        : double.maxFinite;
    final oilPts =
        linearScore(current: kmOil, full: 3000, zero: 5000, maxPts: 20);
    factors.add(HealthFactor(
      label: 'Engine Oil',
      points: oilPts,
      maxPoints: 20,
      status: statusFor(oilPts, 20),
      message: (l) => lastOil == null
          ? l.healthOilNone
          : kmOil < 3000
              ? l.healthOilGood(kmOil.round())
              : oilPts == 0
                  ? l.healthOilOverdue
                  : l.healthOilDue((5000 - kmOil).round()),
    ));

    // 2. Chain maintenance — 15 pts
    final lastChain =
        lastOf(ServiceTypes.chainClean) ?? lastOf(ServiceTypes.chainLube);
    final kmChain = lastChain != null
        ? (vehicle.odometerCurrent - lastChain.odometer).toDouble()
        : double.maxFinite;
    final chainPts =
        linearScore(current: kmChain, full: 800, zero: 1500, maxPts: 15);
    factors.add(HealthFactor(
      label: 'Chain',
      points: chainPts,
      maxPoints: 15,
      status: statusFor(chainPts, 15),
      message: (l) => lastChain == null
          ? l.healthChainNone
          : kmChain < 800
              ? l.healthChainGood(kmChain.round())
              : l.healthChainDue((1500 - kmChain).round()),
    ));

    // 3. Air filter — 10 pts
    final lastAir = lastOf(ServiceTypes.airFilter);
    final kmAir = lastAir != null
        ? (vehicle.odometerCurrent - lastAir.odometer).toDouble()
        : double.maxFinite;
    final airPts =
        linearScore(current: kmAir, full: 8000, zero: 12000, maxPts: 10);
    factors.add(HealthFactor(
      label: 'Air Filter',
      points: airPts,
      maxPoints: 10,
      status: statusFor(airPts, 10),
      message: (l) => lastAir == null
          ? l.healthAirNone
          : kmAir < 8000
              ? l.healthAirGood((kmAir / 1000).toStringAsFixed(1))
              : l.healthAirDue,
    ));

    // 4. Brake pads — 15 pts
    final lastBrakes = lastOf(ServiceTypes.brakePads);
    final kmBrakes = lastBrakes != null
        ? (vehicle.odometerCurrent - lastBrakes.odometer).toDouble()
        : double.maxFinite;
    final brakesPts =
        linearScore(current: kmBrakes, full: 8000, zero: 15000, maxPts: 15);
    factors.add(HealthFactor(
      label: 'Brake Pads',
      points: brakesPts,
      maxPoints: 15,
      status: statusFor(brakesPts, 15),
      message: (l) => lastBrakes == null
          ? l.healthBrakesNone
          : kmBrakes < 8000
              ? l.healthBrakesGood((kmBrakes / 1000).toStringAsFixed(1))
              : l.healthBrakesDue,
    ));

    // 5. Tyres — 10 pts (age-based)
    final lastTyre = lastOf(ServiceTypes.tyres);
    final tyreYears = lastTyre != null
        ? now.difference(lastTyre.date).inDays / 365.0
        : 4.0;
    final tyrePts =
        linearScore(current: tyreYears, full: 2, zero: 4, maxPts: 10);
    factors.add(HealthFactor(
      label: 'Tyres',
      points: tyrePts,
      maxPoints: 10,
      status: statusFor(tyrePts, 10),
      message: (l) => lastTyre == null
          ? l.healthTyresNone
          : tyreYears < 2
              ? l.healthTyresGood((tyreYears * 12).round())
              : l.healthTyresDue,
    ));

    // 6. Battery — 10 pts (age-based)
    final lastBattery = lastOf(ServiceTypes.battery);
    final batteryYears = lastBattery != null
        ? now.difference(lastBattery.date).inDays / 365.0
        : 4.0;
    final batteryPts =
        linearScore(current: batteryYears, full: 2, zero: 4, maxPts: 10);
    factors.add(HealthFactor(
      label: 'Battery',
      points: batteryPts,
      maxPoints: 10,
      status: statusFor(batteryPts, 10),
      message: (l) => lastBattery == null
          ? l.healthBatteryNone
          : batteryYears < 2
              ? l.healthBatteryGood((batteryYears * 12).round())
              : l.healthBatteryDue,
    ));

    // 7. Insurance — 10 pts
    final double insurancePts;
    final String Function(AppLocalizations l) insuranceMsg;
    if (vehicle.insuranceExpiry == null) {
      insurancePts = 0;
      insuranceMsg = (l) => l.healthInsuranceNotSet;
    } else {
      final days = vehicle.insuranceExpiry!.difference(now).inDays;
      insurancePts = days >= 30
          ? 10.0
          : days <= 0
              ? 0.0
              : 10.0 * days / 30;
      insuranceMsg = (l) => days <= 0
          ? l.healthInsuranceExpired
          : days <= 30
              ? l.healthInsuranceExpiring(days)
              : l.healthInsuranceValid(days);
    }
    factors.add(HealthFactor(
      label: 'Insurance',
      points: insurancePts,
      maxPoints: 10,
      status: statusFor(insurancePts, 10),
      message: insuranceMsg,
    ));

    // 8. Fuel economy trend — 10 pts
    final double economyPts;
    final String Function(AppLocalizations l) economyMsg;
    final withMileage = (fuelLogs
          ..sort((a, b) => a.date.compareTo(b.date)))
        .where((f) => f.mileageCalculated != null)
        .toList();
    if (withMileage.length < 3) {
      economyPts = 10;
      economyMsg = (l) => l.healthEconomyNeedMore;
    } else {
      final recent = withMileage.reversed.take(3).toList();
      final recentAvg =
          recent.map((f) => f.mileageCalculated!).reduce((a, b) => a + b) / 3;
      final older = withMileage.reversed.skip(3).take(3).toList();
      if (older.isEmpty) {
        economyPts = 10;
        economyMsg =
            (l) => l.healthEconomyAverage(recentAvg.toStringAsFixed(1));
      } else {
        final olderAvg = older
                .map((f) => f.mileageCalculated!)
                .reduce((a, b) => a + b) /
            older.length;
        final change = (recentAvg - olderAvg) / olderAvg;
        if (change >= -0.05) {
          economyPts = 10;
          economyMsg =
              (l) => l.healthEconomyStable(recentAvg.toStringAsFixed(1));
        } else if (change <= -0.20) {
          economyPts = 0;
          economyMsg = (l) => l.healthEconomyDropping;
        } else {
          economyPts = 10 * (1 - (-change - 0.05) / 0.15);
          economyMsg = (l) => l.healthEconomyDeclining;
        }
      }
    }
    factors.add(HealthFactor(
      label: 'Fuel Economy',
      points: economyPts,
      maxPoints: 10,
      status: statusFor(economyPts, 10),
      message: economyMsg,
    ));

    final total =
        factors.fold(0.0, (sum, f) => sum + f.points).round().clamp(0, 100);

    return HealthScore(
      score: total,
      grade: _grade(total),
      factors: factors,
    );
  }

  HealthGrade _grade(int score) {
    if (score >= 90) return HealthGrade.excellent;
    if (score >= 75) return HealthGrade.good;
    if (score >= 50) return HealthGrade.fair;
    if (score >= 25) return HealthGrade.poor;
    return HealthGrade.critical;
  }
}
