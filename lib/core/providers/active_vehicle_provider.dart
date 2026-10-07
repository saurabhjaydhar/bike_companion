import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

final activeVehicleIdProvider = StateProvider<String?>((ref) => null);

Future<void> setActiveVehicle(WidgetRef ref, String vehicleId) async {
  ref.read(activeVehicleIdProvider.notifier).state = vehicleId;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(SharedPrefKeys.activeVehicleId, vehicleId);
}

/// The vehicle the app should open on: the one the rider last used if it
/// still exists, otherwise their first vehicle, or null with an empty garage.
String? pickHomeVehicle(List<String> ids, String? saved) =>
    ids.contains(saved) ? saved : (ids.isEmpty ? null : ids.first);
