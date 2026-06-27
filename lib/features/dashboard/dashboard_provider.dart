import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/bike.dart';
import '../../data/models/fuel_log.dart';
import '../../data/models/health_score.dart';
import '../../data/models/service_record.dart';
import '../../data/repositories/bike_repository.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../core/services/health_score_service.dart';
import '../../main.dart';

sealed class ActivityItem {
  DateTime get date;
}

class FuelActivity extends ActivityItem {
  final FuelLog log;
  FuelActivity(this.log);
  @override
  DateTime get date => log.date;
}

class ServiceActivity extends ActivityItem {
  final ServiceRecord record;
  ServiceActivity(this.record);
  @override
  DateTime get date => record.date;
}

class DashboardState {
  final Bike bike;
  final List<Bike> allBikes;
  final HealthScore healthScore;
  final FuelLog? lastFuelLog;
  final double? avgMileage;
  final ServiceRecord? nextService;
  final double monthTotal;
  final List<ActivityItem> recentActivity;

  const DashboardState({
    required this.bike,
    required this.allBikes,
    required this.healthScore,
    required this.lastFuelLog,
    required this.avgMileage,
    required this.nextService,
    required this.monthTotal,
    required this.recentActivity,
  });
}

class DashboardNotifier
    extends FamilyAsyncNotifier<DashboardState, String> {
  @override
  Future<DashboardState> build(String arg) => _load(arg);

  Future<DashboardState> _load(String bikeId) async {
    final bikeRepo = getIt<BikeRepository>();
    final serviceRepo = getIt<ServiceRepository>();
    final fuelRepo = getIt<FuelRepository>();
    final expenseRepo = getIt<ExpenseRepository>();
    final healthService = getIt<HealthScoreService>();
    final now = DateTime.now();

    final results = await Future.wait([
      bikeRepo.getBikeById(bikeId),
      bikeRepo.getAllBikes(),
      serviceRepo.getServiceHistory(bikeId),
      fuelRepo.getFuelLogs(bikeId, limit: 20),
      expenseRepo.getMonthlyTotal(bikeId, now.year, now.month),
    ]);

    final bike = results[0] as Bike?;
    if (bike == null) throw StateError('Bike $bikeId not found');

    final allBikes = results[1] as List<Bike>;
    final services = results[2] as List<ServiceRecord>;
    final fuelLogs = results[3] as List<FuelLog>;
    final monthTotal = results[4] as double;

    final lastFuelLog = fuelLogs.isEmpty ? null : fuelLogs.first;
    final avgMileage = await fuelRepo.getAverageMileage(bikeId);
    final nextService = await serviceRepo.getNextDueService(bikeId);

    final healthScore = healthService.compute(
      bike: bike,
      services: services,
      fuelLogs: fuelLogs,
    );

    // Merge last 3 fuel + service entries, sorted newest first
    final activity = <ActivityItem>[
      ...fuelLogs.take(3).map(FuelActivity.new),
      ...services.take(3).map(ServiceActivity.new),
    ]..sort((a, b) => b.date.compareTo(a.date));

    return DashboardState(
      bike: bike,
      allBikes: allBikes,
      healthScore: healthScore,
      lastFuelLog: lastFuelLog,
      avgMileage: avgMileage,
      nextService: nextService,
      monthTotal: monthTotal,
      recentActivity: activity.take(3).toList(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(arg));
  }
}

final dashboardProvider = AsyncNotifierProvider.family<DashboardNotifier,
    DashboardState, String>(
  DashboardNotifier.new,
);
