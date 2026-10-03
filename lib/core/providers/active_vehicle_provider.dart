import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

final activeVehicleIdProvider = StateProvider<String?>((ref) => null);

Future<void> setActiveVehicle(WidgetRef ref, String vehicleId) async {
  ref.read(activeVehicleIdProvider.notifier).state = vehicleId;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(SharedPrefKeys.activeVehicleId, vehicleId);
}
