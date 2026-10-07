import '../../data/models/fuel_log.dart';

/// Smart defaults for the fuel log, so a typical fill-up needs no typing:
/// the odometer is guessed from the rider's usual distance between fills and
/// the amount is one tap on a chip.

/// The typical distance between fill-ups: the median gap over the last few
/// fills, given newest first. Null until there are two fills to compare.
int? usualTripKm(List<FuelLog> logsNewestFirst, {int lastN = 5}) {
  final logs = logsNewestFirst.take(lastN + 1).toList();
  final gaps = [
    for (var i = 0; i + 1 < logs.length; i++)
      logs[i].odometer - logs[i + 1].odometer,
  ].where((g) => g > 0).toList()
    ..sort();
  if (gaps.isEmpty) return null;
  final mid = gaps.length ~/ 2;
  return gaps.length.isOdd ? gaps[mid] : ((gaps[mid - 1] + gaps[mid]) / 2).round();
}

/// The odometer reading to start the form on, or null to leave it blank.
///
/// A reading newer than the last fill (say, from "Update odometer") is the
/// best guess. Otherwise it is the last fill plus the usual distance,
/// rounded to 10 km so the nudge chips land on round numbers.
int? suggestOdometer({
  required int vehicleOdometer,
  FuelLog? lastLog,
  int? usualTrip,
}) {
  final last = lastLog?.odometer;
  if (last == null) return vehicleOdometer > 0 ? vehicleOdometer : null;
  if (vehicleOdometer > last) return vehicleOdometer;
  if (usualTrip == null) return null;
  return ((last + usualTrip) / 10).round() * 10;
}

/// Amount chips: what the rider paid recently (most frequent first), filled
/// up with common round amounts, shown smallest first.
List<int> amountChips(List<FuelLog> logsNewestFirst, {int count = 4}) {
  final freq = <int, int>{};
  for (final log in logsNewestFirst.take(10)) {
    final a = log.amount;
    if (a == null || a <= 0) continue;
    final rounded = a.round();
    freq[rounded] = (freq[rounded] ?? 0) + 1;
  }
  final recent = freq.keys.toList()
    ..sort((a, b) => freq[b]!.compareTo(freq[a]!));
  final picks = <int>{...recent.take(count - 1)};
  for (final d in const [200, 500, 1000, 300, 2000]) {
    if (picks.length >= count) break;
    picks.add(d);
  }
  return picks.toList()..sort();
}
