import '../../data/models/bike.dart';
import '../../data/models/fuel_log.dart';
import '../../data/models/health_score.dart';
import '../../data/models/service_record.dart';
import '../constants/app_constants.dart';

class HealthScoreService {
  HealthScore compute({
    required Bike bike,
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
        ? (bike.odometerCurrent - lastOil.odometer).toDouble()
        : double.maxFinite;
    final oilPts =
        linearScore(current: kmOil, full: 3000, zero: 5000, maxPts: 20);
    factors.add(HealthFactor(
      label: 'Engine Oil',
      points: oilPts,
      maxPoints: 20,
      status: statusFor(oilPts, 20),
      message: lastOil == null
          ? 'No oil change recorded — log your first service'
          : kmOil < 3000
              ? 'Oil changed ${kmOil.round()} km ago — all good'
              : oilPts == 0
                  ? 'Oil change overdue!'
                  : 'Oil change due in ~${(5000 - kmOil).round()} km',
    ));

    // 2. Chain maintenance — 15 pts
    final lastChain =
        lastOf(ServiceTypes.chainClean) ?? lastOf(ServiceTypes.chainLube);
    final kmChain = lastChain != null
        ? (bike.odometerCurrent - lastChain.odometer).toDouble()
        : double.maxFinite;
    final chainPts =
        linearScore(current: kmChain, full: 800, zero: 1500, maxPts: 15);
    factors.add(HealthFactor(
      label: 'Chain',
      points: chainPts,
      maxPoints: 15,
      status: statusFor(chainPts, 15),
      message: lastChain == null
          ? 'No chain service recorded'
          : kmChain < 800
              ? 'Chain serviced ${kmChain.round()} km ago'
              : 'Chain service due in ~${(1500 - kmChain).round()} km',
    ));

    // 3. Air filter — 10 pts
    final lastAir = lastOf(ServiceTypes.airFilter);
    final kmAir = lastAir != null
        ? (bike.odometerCurrent - lastAir.odometer).toDouble()
        : double.maxFinite;
    final airPts =
        linearScore(current: kmAir, full: 8000, zero: 12000, maxPts: 10);
    factors.add(HealthFactor(
      label: 'Air Filter',
      points: airPts,
      maxPoints: 10,
      status: statusFor(airPts, 10),
      message: lastAir == null
          ? 'No air filter service recorded'
          : kmAir < 8000
              ? 'Air filter changed ${(kmAir / 1000).toStringAsFixed(1)}k km ago'
              : 'Air filter change due soon',
    ));

    // 4. Brake pads — 15 pts
    final lastBrakes = lastOf(ServiceTypes.brakePads);
    final kmBrakes = lastBrakes != null
        ? (bike.odometerCurrent - lastBrakes.odometer).toDouble()
        : double.maxFinite;
    final brakesPts =
        linearScore(current: kmBrakes, full: 8000, zero: 15000, maxPts: 15);
    factors.add(HealthFactor(
      label: 'Brake Pads',
      points: brakesPts,
      maxPoints: 15,
      status: statusFor(brakesPts, 15),
      message: lastBrakes == null
          ? 'No brake service recorded'
          : kmBrakes < 8000
              ? 'Brakes checked ${(kmBrakes / 1000).toStringAsFixed(1)}k km ago'
              : 'Brake inspection recommended',
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
      message: lastTyre == null
          ? 'No tyre service recorded'
          : tyreYears < 2
              ? 'Tyres replaced ${(tyreYears * 12).round()} months ago'
              : 'Tyre inspection recommended',
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
      message: lastBattery == null
          ? 'No battery service recorded'
          : batteryYears < 2
              ? 'Battery replaced ${(batteryYears * 12).round()} months ago'
              : 'Battery check recommended',
    ));

    // 7. Insurance — 10 pts
    final double insurancePts;
    final String insuranceMsg;
    if (bike.insuranceExpiry == null) {
      insurancePts = 0;
      insuranceMsg = 'Insurance expiry date not set';
    } else {
      final days = bike.insuranceExpiry!.difference(now).inDays;
      insurancePts = days >= 30
          ? 10.0
          : days <= 0
              ? 0.0
              : 10.0 * days / 30;
      insuranceMsg = days <= 0
          ? 'Insurance EXPIRED — renew immediately'
          : days <= 30
              ? 'Insurance expires in $days days — renew now'
              : 'Insurance valid for $days more days';
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
    final String economyMsg;
    final withMileage = (fuelLogs
          ..sort((a, b) => a.date.compareTo(b.date)))
        .where((f) => f.mileageCalculated != null)
        .toList();
    if (withMileage.length < 3) {
      economyPts = 10;
      economyMsg = 'Log more fill-ups to track fuel economy';
    } else {
      final recent = withMileage.reversed.take(3).toList();
      final recentAvg =
          recent.map((f) => f.mileageCalculated!).reduce((a, b) => a + b) / 3;
      final older = withMileage.reversed.skip(3).take(3).toList();
      if (older.isEmpty) {
        economyPts = 10;
        economyMsg = 'Average: ${recentAvg.toStringAsFixed(1)} km/L';
      } else {
        final olderAvg = older
                .map((f) => f.mileageCalculated!)
                .reduce((a, b) => a + b) /
            older.length;
        final change = (recentAvg - olderAvg) / olderAvg;
        if (change >= -0.05) {
          economyPts = 10;
          economyMsg = 'Fuel economy stable at ${recentAvg.toStringAsFixed(1)} km/L';
        } else if (change <= -0.20) {
          economyPts = 0;
          economyMsg = 'Fuel economy dropping — service may be needed';
        } else {
          economyPts = 10 * (1 - (-change - 0.05) / 0.15);
          economyMsg = 'Fuel economy slightly declining — monitor it';
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
