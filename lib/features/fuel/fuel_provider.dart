import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fuel_log.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../main.dart';

class FuelHistoryNotifier extends FamilyAsyncNotifier<List<FuelLog>, String> {
  @override
  Future<List<FuelLog>> build(String arg) =>
      getIt<FuelRepository>().getFuelLogs(arg);

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => getIt<FuelRepository>().getFuelLogs(arg));
  }
}

final fuelHistoryProvider =
    AsyncNotifierProvider.family<FuelHistoryNotifier, List<FuelLog>, String>(
  FuelHistoryNotifier.new,
);
