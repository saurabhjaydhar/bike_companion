import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// The few product events Garajo records. Parameters are counts and
/// categories only — never registration numbers, names, places or amounts.
class Analytics {
  Analytics._();

  static Future<void> _log(String name, Map<String, Object> params) async {
    try {
      await FirebaseAnalytics.instance.logEvent(name: name, parameters: params);
    } catch (e) {
      // Analytics must never break the app (e.g. Firebase not set up).
      debugPrint('Analytics: $name not sent: $e');
    }
  }

  /// An RC scan finished. [reader] is "gemini" or "onDevice".
  static Future<void> rcScan({
    required bool found,
    required String reader,
    required int photos,
  }) => _log('rc_scan', {
    'found': found ? 1 : 0,
    'reader': reader,
    'photos': photos,
  });

  /// A vehicle was saved. [source] is how its details were filled in:
  /// "scan", "lookup" or "manual".
  static Future<void> vehicleAdded({
    required String type,
    required String source,
  }) => _log('vehicle_added', {'type': type, 'source': source});

  static Future<void> budgetSet({
    required bool monthly,
    required bool yearly,
  }) => _log('budget_set', {
    'monthly': monthly ? 1 : 0,
    'yearly': yearly ? 1 : 0,
  });

  /// Reminders currently scheduled — sent once per app session.
  static Future<void> remindersScheduled(int count) =>
      _log('reminders_scheduled', {'count': count});
}
