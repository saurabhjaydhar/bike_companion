import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/account_data_service.dart';

/// Changes whenever the local garage is wiped or replaced (sign-out, account
/// switch, restore). Data providers watch it so they reload instead of
/// showing the previous account's records.
final localDataEpochProvider = Provider<int>((ref) {
  final changes = AccountDataService.changes;
  void reload() => ref.invalidateSelf();
  changes.addListener(reload);
  ref.onDispose(() => changes.removeListener(reload));
  return changes.value;
});
