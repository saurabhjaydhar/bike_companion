import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/health_score_service.dart';
import '../../data/models/health_score.dart';
import '../../data/models/service_record.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';

class ServiceItem {
  final String type;
  final ServiceRecord? lastRecord;
  final HealthFactor? factor;

  const ServiceItem({
    required this.type,
    this.lastRecord,
    this.factor,
  });

  HealthStatus get status => factor?.status ?? HealthStatus.danger;
  String statusLabel(AppLocalizations l) {
    switch (status) {
      case HealthStatus.good: return l.serviceStatusGood;
      case HealthStatus.warning: return l.serviceDueSoon;
      case HealthStatus.danger:
        return lastRecord == null ? l.dashboardNotLogged : l.serviceStatusOverdue;
    }
  }
}

class ServiceState {
  final List<ServiceItem> dueItems;
  final List<ServiceRecord> history;

  const ServiceState({required this.dueItems, required this.history});
}

class ServiceNotifier extends FamilyAsyncNotifier<ServiceState, String> {
  @override
  Future<ServiceState> build(String arg) => _load(arg);

  Future<ServiceState> _load(String vehicleId) async {
    final vehicleRepo = getIt<VehicleRepository>();
    final serviceRepo = getIt<ServiceRepository>();
    final fuelRepo = getIt<FuelRepository>();

    final vehicle = await vehicleRepo.getVehicleById(vehicleId);
    if (vehicle == null) throw StateError('Vehicle not found');

    final history = await serviceRepo.getServiceHistory(vehicleId);
    final fuelLogs = await fuelRepo.getFuelLogs(vehicleId, limit: 10);

    final health = getIt<HealthScoreService>().compute(
      vehicle: vehicle,
      services: history,
      fuelLogs: fuelLogs,
    );

    final factorMap = {for (final f in health.factors) f.label: f};

    final typeToFactorLabel = {
      ServiceTypes.oilChange: 'Engine Oil',
      ServiceTypes.chainClean: 'Chain',
      ServiceTypes.chainLube: 'Chain',
      ServiceTypes.airFilter: 'Air Filter',
      ServiceTypes.brakePads: 'Brake Pads',
      ServiceTypes.tyres: 'Tyres',
      ServiceTypes.battery: 'Battery',
    };

    final latestPerType = await serviceRepo.getLatestPerType(vehicleId);

    final trackableTypes = [
      ServiceTypes.oilChange,
      ServiceTypes.airFilter,
      ServiceTypes.chainClean,
      ServiceTypes.brakePads,
      ServiceTypes.tyres,
      ServiceTypes.battery,
      ServiceTypes.coolant,
      ServiceTypes.other,
    ];

    final dueItems = trackableTypes.map((type) {
      final factorLabel = typeToFactorLabel[type];
      final factor = factorLabel != null ? factorMap[factorLabel] : null;
      return ServiceItem(
        type: type,
        lastRecord: latestPerType[type],
        factor: factor,
      );
    }).toList()
      ..sort((a, b) => a.status.index.compareTo(b.status.index));

    return ServiceState(dueItems: dueItems, history: history);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(arg));
  }

  Future<void> addService(ServiceRecord record) async {
    await getIt<ServiceRepository>().insertService(record);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(arg));
  }
}

final serviceProvider =
    AsyncNotifierProvider.family<ServiceNotifier, ServiceState, String>(
  ServiceNotifier.new,
);
