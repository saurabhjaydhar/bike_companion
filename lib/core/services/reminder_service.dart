import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/health_score.dart';
import '../../data/models/service_record.dart';
import '../../data/models/vehicle.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/repositories/fuel_repository.dart';
import '../../data/repositories/service_repository.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../l10n/l10n.dart';
import 'health_score_service.dart';
import 'notification_service.dart';
import 'reminder_planner.dart';

/// Keeps scheduled reminders in step with the data: expiry and service-date
/// reminders are re-planned after every change, and service items are
/// checked when the odometer or service history changes.
class ReminderService {
  final VehicleRepository _vehicles;
  final DocumentRepository _documents;
  final ServiceRepository _services;
  final FuelRepository _fuel;
  final HealthScoreService _health;

  ReminderService(
    this._vehicles,
    this._documents,
    this._services,
    this._fuel,
    this._health,
  );

  static const _mutedKey = 'reminders_muted_vehicles';
  static const _serviceDueKey = 'reminders_service_due_notified';

  /// iOS keeps at most 64 pending notifications; leave a little room.
  static const _maxScheduled = 60;

  Timer? _debounce;
  bool _running = false;
  bool _runAgain = false;

  /// Re-plans reminders shortly after data changes, batching bursts of
  /// writes (e.g. a restore) into one pass.
  void scheduleRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), refresh);
  }

  /// Re-plans every reminder now.
  Future<void> refresh() async {
    if (_running) {
      _runAgain = true;
      return;
    }
    _running = true;
    try {
      do {
        _runAgain = false;
        await _refreshOnce();
      } while (_runAgain);
    } catch (e) {
      debugPrint('Reminders: refresh failed: $e');
    } finally {
      _running = false;
    }
  }

  Future<void> _refreshOnce() async {
    final vehicles = await _vehicles.getAllVehicles();
    final services = <String, List<ServiceRecord>>{
      for (final v in vehicles) v.id: await _services.getServiceHistory(v.id),
    };
    final items = dueItems(
      vehicles: vehicles,
      documents: [
        for (final v in vehicles) ...await _documents.getDocuments(v.id),
      ],
      services: [for (final list in services.values) ...list],
    );
    final muted = await mutedVehicleIds();
    final l = await loadAppLocalizations();
    final names = {for (final v in vehicles) v.id: v.name};

    final plan = planReminders(items, now: DateTime.now(), mutedVehicleIds: muted)
      ..sort((a, b) => a.at.compareTo(b.at));
    final keep = plan.take(_maxScheduled).toList();
    final keepIds = {for (final p in keep) p.id};

    for (final id in await NotificationService.scheduledIds(
      ReminderPayload.prefix,
    )) {
      if (!keepIds.contains(id)) await NotificationService.cancel(id);
    }
    for (final p in keep) {
      await NotificationService.schedule(
        id: p.id,
        title: l.dueReminderTitle(p.item, p.daysBefore),
        body: l.notifDueBody(
          names[p.item.vehicleId] ?? '',
          DateFormat.yMMMd(l.localeName).format(p.item.due),
        ),
        at: p.at,
        payload: p.item.payload,
      );
    }

    await _notifyServiceDue(vehicles, services, muted, l);
  }

  /// Notifies once when a logged service item starts needing attention, and
  /// once more if it becomes overdue. Items back in good shape are forgotten,
  /// so they can notify again next time.
  Future<void> _notifyServiceDue(
    List<Vehicle> vehicles,
    Map<String, List<ServiceRecord>> services,
    Set<String> muted,
    AppLocalizations l,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final notified = (prefs.getStringList(_serviceDueKey) ?? const []).toSet();
    final current = <String>{};

    for (final v in vehicles) {
      if (muted.contains(v.id)) continue;
      final health = _health.compute(
        vehicle: v,
        services: services[v.id] ?? const [],
        fuelLogs: await _fuel.getFuelLogs(v.id, limit: 10),
      );
      for (final f in health.factors) {
        if (f.serviceType == null || f.status == HealthStatus.good) continue;
        final key = '${v.id}|${f.serviceType}|${f.status.name}';
        current.add(key);
        if (notified.contains(key)) continue;
        await NotificationService.showNow(
          id: notificationId('service:$key'),
          title: l.notifServiceOverdueTitle(v.name),
          body: f.localizedMessage(l),
          payload: ReminderPayload(
            kind: DueKind.service,
            vehicleId: v.id,
          ).encode(),
        );
      }
    }
    await prefs.setStringList(_serviceDueKey, current.toList());
  }

  /// Vehicles whose reminders the user turned off.
  Future<Set<String>> mutedVehicleIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_mutedKey) ?? const []).toSet();
  }

  Future<void> setMuted(String vehicleId, bool muted) async {
    final ids = await mutedVehicleIds();
    muted ? ids.add(vehicleId) : ids.remove(vehicleId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_mutedKey, ids.toList());
    await refresh();
  }
}
