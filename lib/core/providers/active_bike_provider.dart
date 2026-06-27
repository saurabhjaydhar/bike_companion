import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

final activeBikeIdProvider = StateProvider<String?>((ref) => null);

Future<void> setActiveBike(WidgetRef ref, String bikeId) async {
  ref.read(activeBikeIdProvider.notifier).state = bikeId;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(SharedPrefKeys.activeBikeId, bikeId);
}
