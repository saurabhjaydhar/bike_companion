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

    // Intervals depend on the vehicle: a car's oil lasts ~10,000 km, a
    // bike's 3,000–5,000; cars and scooters have no chain.
    final p = vehicle.type.maintenance;

    // 1. Engine oil — 20 pts
    final lastOil = lastOf(ServiceTypes.oilChange);
    final kmOil = lastOil != null
        ? (vehicle.odometerCurrent - lastOil.odometer).toDouble()
        : double.maxFinite;
    final oilPts =
        linearScore(
            current: kmOil, full: p.oilKm.good, zero: p.oilKm.due, maxPts: 20);
    factors.add(HealthFactor(
      label: 'Engine Oil',
      serviceType: lastOil == null ? null : ServiceTypes.oilChange,
      points: oilPts,
      maxPoints: 20,
      status: statusFor(oilPts, 20),
      message: (l) => lastOil == null
          ? l.healthOilNone
          : kmOil < p.oilKm.good
              ? l.healthOilGood(kmOil.round())
              : oilPts == 0
                  ? l.healthOilOverdue
                  : l.healthOilDue((p.oilKm.due - kmOil).round()),
    ));

    // 2. Chain maintenance — 15 pts (vehicles with a chain only)
    if (p.chainKm case final chain?) {
      final lastChain =
          lastOf(ServiceTypes.chainClean) ?? lastOf(ServiceTypes.chainLube);
      final kmChain = lastChain != null
          ? (vehicle.odometerCurrent - lastChain.odometer).toDouble()
          : double.maxFinite;
      final chainPts = linearScore(
          current: kmChain, full: chain.good, zero: chain.due, maxPts: 15);
      factors.add(HealthFactor(
        label: 'Chain',
        serviceType: lastChain?.serviceType,
        points: chainPts,
        maxPoints: 15,
        status: statusFor(chainPts, 15),
        message: (l) => lastChain == null
            ? l.healthChainNone
            : kmChain < chain.good
                ? l.healthChainGood(kmChain.round())
                : l.healthChainDue((chain.due - kmChain).round()),
      ));
    }

    // 3. Air filter — 10 pts
    final lastAir = lastOf(ServiceTypes.airFilter);
    final kmAir = lastAir != null
        ? (vehicle.odometerCurrent - lastAir.odometer).toDouble()
        : double.maxFinite;
    final airPts =
        linearScore(
        current: kmAir,
        full: p.airFilterKm.good,
        zero: p.airFilterKm.due,
        maxPts: 10);
    factors.add(HealthFactor(
      label: 'Air Filter',
      serviceType: lastAir == null ? null : ServiceTypes.airFilter,
      points: airPts,
      maxPoints: 10,
      status: statusFor(airPts, 10),
      message: (l) => lastAir == null
          ? l.healthAirNone
          : kmAir < p.airFilterKm.good
              ? l.healthAirGood((kmAir / 1000).toStringAsFixed(1))
              : l.healthAirDue,
    ));

    // 4. Brake pads — 15 pts
    final lastBrakes = lastOf(ServiceTypes.brakePads);
    final kmBrakes = lastBrakes != null
        ? (vehicle.odometerCurrent - lastBrakes.odometer).toDouble()
        : double.maxFinite;
    final brakesPts =
        linearScore(
        current: kmBrakes,
        full: p.brakePadsKm.good,
        zero: p.brakePadsKm.due,
        maxPts: 15);
    factors.add(HealthFactor(
      label: 'Brake Pads',
      serviceType: lastBrakes == null ? null : ServiceTypes.brakePads,
      points: brakesPts,
      maxPoints: 15,
      status: statusFor(brakesPts, 15),
      message: (l) => lastBrakes == null
          ? l.healthBrakesNone
          : kmBrakes < p.brakePadsKm.good
              ? l.healthBrakesGood((kmBrakes / 1000).toStringAsFixed(1))
              : l.healthBrakesDue,
    ));

    // 5. Tyres — 10 pts (age-based)
    final lastTyre = lastOf(ServiceTypes.tyres);
    final tyreYears = lastTyre != null
        ? now.difference(lastTyre.date).inDays / 365.0
        : p.tyreYears.due;
    final tyrePts =
        linearScore(
        current: tyreYears,
        full: p.tyreYears.good,
        zero: p.tyreYears.due,
        maxPts: 10);
    factors.add(HealthFactor(
      label: 'Tyres',
      serviceType: lastTyre == null ? null : ServiceTypes.tyres,
      points: tyrePts,
      maxPoints: 10,
      status: statusFor(tyrePts, 10),
      message: (l) => lastTyre == null
          ? l.healthTyresNone
          : tyreYears < p.tyreYears.good
              ? l.healthTyresGood((tyreYears * 12).round())
              : l.healthTyresDue,
    ));

    // 6. Battery — 10 pts (age-based)
    final lastBattery = lastOf(ServiceTypes.battery);
    final batteryYears = lastBattery != null
        ? now.difference(lastBattery.date).inDays / 365.0
        : p.batteryYears.due;
    final batteryPts =
        linearScore(
        current: batteryYears,
        full: p.batteryYears.good,
        zero: p.batteryYears.due,
        maxPts: 10);
    factors.add(HealthFactor(
      label: 'Battery',
      serviceType: lastBattery == null ? null : ServiceTypes.battery,
      points: batteryPts,
      maxPoints: 10,
      status: statusFor(batteryPts, 10),
      message: (l) => lastBattery == null
          ? l.healthBatteryNone
          : batteryYears < p.batteryYears.good
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
    // Sort a copy: callers keep their own order (e.g. newest first).
    final withMileage = ([...fuelLogs]
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

    // Out of 100 whichever factors apply (cars have no chain factor).
    final points = factors.fold(0.0, (sum, f) => sum + f.points);
    final maxPoints = factors.fold(0.0, (sum, f) => sum + f.maxPoints);
    final total = maxPoints > 0
        ? (points / maxPoints * 100).round().clamp(0, 100)
        : 0;

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
