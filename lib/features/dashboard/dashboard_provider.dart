import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/local_data_provider.dart';
import '../../data/models/vehicle.dart';
import '../../data/models/fuel_log.dart';
import '../../data/models/health_score.dart';
import '../../data/models/service_record.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../core/services/spending.dart';
import '../../data/repositories/ledger_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../core/services/health_score_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/reminder_planner.dart';
import '../../core/services/reminder_service.dart';
import '../../data/repositories/document_repository.dart';
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
  final Vehicle vehicle;
  final List<Vehicle> allVehicles;
  final HealthScore healthScore;
  final FuelLog? lastFuelLog;
  final double? avgMileage;
  final ServiceRecord? nextService;
  /// Spent this month: expenses, fuel and services.
  final double monthTotal;

  /// Lifetime spending per km driven; null until odometer readings allow it.
  final double? costPerKm;

  /// Monthly budget suggested from recent spending.
  final double? budgetSuggestion;
  final List<ActivityItem> recentActivity;

  /// Expiries and service dates for this vehicle, soonest first.
  final List<DueItem> dueItems;

  /// Whether the app may show notifications.
  final bool remindersPermitted;

  /// Whether the user turned reminders off for this vehicle.
  final bool remindersMuted;

  const DashboardState({
    required this.vehicle,
    required this.allVehicles,
    required this.healthScore,
    required this.lastFuelLog,
    required this.avgMileage,
    required this.nextService,
    required this.monthTotal,
    required this.costPerKm,
    required this.budgetSuggestion,
    required this.recentActivity,
    required this.dueItems,
    required this.remindersPermitted,
    required this.remindersMuted,
  });
}

class DashboardNotifier
    extends FamilyAsyncNotifier<DashboardState, String> {
  @override
  Future<DashboardState> build(String arg) {
    ref.watch(localDataEpochProvider);
    return _load(arg);
  }

  Future<DashboardState> _load(String vehicleId) async {
    final vehicleRepo = getIt<VehicleRepository>();
    final serviceRepo = getIt<ServiceRepository>();
    final fuelRepo = getIt<FuelRepository>();
    final ledger = getIt<LedgerRepository>();
    final healthService = getIt<HealthScoreService>();
    final now = DateTime.now();

    final results = await Future.wait([
      vehicleRepo.getVehicleById(vehicleId),
      vehicleRepo.getAllVehicles(),
      serviceRepo.getServiceHistory(vehicleId),
      fuelRepo.getFuelLogs(vehicleId, limit: 20),
      ledger.total(
        vehicleId: vehicleId,
        from: DateTime(now.year, now.month),
        to: DateTime(now.year, now.month + 1),
      ),
    ]);

    final vehicle = results[0] as Vehicle?;
    if (vehicle == null) throw StateError('Vehicle $vehicleId not found');

    final allVehicles = results[1] as List<Vehicle>;
    final services = results[2] as List<ServiceRecord>;
    final fuelLogs = results[3] as List<FuelLog>;
    final monthTotal = results[4] as double;

    final lastFuelLog = fuelLogs.isEmpty ? null : fuelLogs.first;
    final avgMileage = await fuelRepo.getAverageMileage(vehicleId);
    final nextService = await serviceRepo.getNextDueService(vehicleId);

    final healthScore = healthService.compute(
      vehicle: vehicle,
      services: services,
      fuelLogs: fuelLogs,
    );

    // Lifetime cost per km.
    final readings = await ledger.odometerReadings(vehicleId);
    final firstDay = readings.isEmpty ? now : readings.first.date;
    final km = kmDriven(readings, firstDay, now.add(const Duration(days: 1)));
    final lifetime = await ledger.total(
        vehicleId: vehicleId,
        from: DateTime(1970),
        to: now.add(const Duration(days: 1)));

    final recentMonths = [
      for (var i = 3; i >= 1; i--)
        MonthTotal(
          DateTime(now.year, now.month - i),
          await ledger.total(
            vehicleId: vehicleId,
            from: DateTime(now.year, now.month - i),
            to: DateTime(now.year, now.month - i + 1),
          ),
        ),
    ];

    final documents =
        await getIt<DocumentRepository>().getDocuments(vehicleId);
    final due = dueItems(
      vehicles: [vehicle],
      documents: documents,
      services: services,
    );
    final permitted = await NotificationService.isPermitted();
    final muted =
        (await getIt<ReminderService>().mutedVehicleIds()).contains(vehicleId);

    // Merge last 3 fuel + service entries, sorted newest first
    final activity = <ActivityItem>[
      ...fuelLogs.take(3).map(FuelActivity.new),
      ...services.take(3).map(ServiceActivity.new),
    ]..sort((a, b) => b.date.compareTo(a.date));

    return DashboardState(
      vehicle: vehicle,
      allVehicles: allVehicles,
      healthScore: healthScore,
      lastFuelLog: lastFuelLog,
      avgMileage: avgMileage,
      nextService: nextService,
      monthTotal: monthTotal,
      costPerKm: km != null && lifetime > 0 ? lifetime / km : null,
      budgetSuggestion: suggestMonthlyBudget(recentMonths),
      recentActivity: activity.take(3).toList(),
      dueItems: due,
      remindersPermitted: permitted,
      remindersMuted: muted,
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
