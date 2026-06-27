import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../services/sync_service.dart';

final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none));
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).value ?? true;
});

/// Watches connectivity and triggers a Firestore sync when coming back online.
/// Watch this provider once from the app root to activate it.
final syncOnReconnectProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<bool>>(connectivityProvider, (previous, next) {
    final wasOnline = previous?.valueOrNull ?? false;
    final isNowOnline = next.valueOrNull ?? false;
    if (!wasOnline && isNowOnline) {
      getIt<SyncService>().pushPending();
    }
  });
});
