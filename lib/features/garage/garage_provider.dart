import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/bike.dart';
import '../../data/models/health_score.dart';
import '../../data/repositories/bike_repository.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../core/services/health_score_service.dart';
import '../../main.dart';

class GarageItem {
  final Bike bike;
  final HealthScore healthScore;
  final double monthTotal;

  const GarageItem({
    required this.bike,
    required this.healthScore,
    required this.monthTotal,
  });

  bool get hasAlerts => healthScore.alerts.isNotEmpty;
}

class GarageNotifier extends AsyncNotifier<List<GarageItem>> {
  @override
  Future<List<GarageItem>> build() => _load();

  Future<List<GarageItem>> _load() async {
    final bikes = await getIt<BikeRepository>().getAllBikes();
    final now = DateTime.now();
    return Future.wait(bikes.map((bike) async {
      final services =
          await getIt<ServiceRepository>().getServiceHistory(bike.id);
      final fuelLogs =
          await getIt<FuelRepository>().getFuelLogs(bike.id, limit: 10);
      final monthTotal = await getIt<ExpenseRepository>()
          .getMonthlyTotal(bike.id, now.year, now.month);
      final health = getIt<HealthScoreService>().compute(
        bike: bike,
        services: services,
        fuelLogs: fuelLogs,
      );
      return GarageItem(bike: bike, healthScore: health, monthTotal: monthTotal);
    }));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> deleteBike(String id) async {
    await getIt<BikeRepository>().deleteBike(id);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final garageProvider =
    AsyncNotifierProvider<GarageNotifier, List<GarageItem>>(
  GarageNotifier.new,
);
