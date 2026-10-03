import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vehicle.dart';
import '../../data/models/health_score.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../core/services/health_score_service.dart';
import '../../main.dart';

class GarageItem {
  final Vehicle vehicle;
  final HealthScore healthScore;
  final double monthTotal;

  const GarageItem({
    required this.vehicle,
    required this.healthScore,
    required this.monthTotal,
  });

  bool get hasAlerts => healthScore.alerts.isNotEmpty;
}

class GarageNotifier extends AsyncNotifier<List<GarageItem>> {
  @override
  Future<List<GarageItem>> build() => _load();

  Future<List<GarageItem>> _load() async {
    final vehicles = await getIt<VehicleRepository>().getAllVehicles();
    final now = DateTime.now();
    return Future.wait(vehicles.map((vehicle) async {
      final services =
          await getIt<ServiceRepository>().getServiceHistory(vehicle.id);
      final fuelLogs =
          await getIt<FuelRepository>().getFuelLogs(vehicle.id, limit: 10);
      final monthTotal = await getIt<ExpenseRepository>()
          .getMonthlyTotal(vehicle.id, now.year, now.month);
      final health = getIt<HealthScoreService>().compute(
        vehicle: vehicle,
        services: services,
        fuelLogs: fuelLogs,
      );
      return GarageItem(vehicle: vehicle, healthScore: health, monthTotal: monthTotal);
    }));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> deleteVehicle(String id) async {
    await getIt<VehicleRepository>().deleteVehicle(id);
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

final garageProvider =
    AsyncNotifierProvider<GarageNotifier, List<GarageItem>>(
  GarageNotifier.new,
);
