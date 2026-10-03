import '../../data/models/document.dart';
import '../../data/models/service_record.dart';
import '../../data/models/vehicle.dart';
import '../constants/app_constants.dart';
import 'notification_service.dart' show notificationId;

/// What can expire or fall due.
enum DueKind {
  insurance,
  puc,
  registration,
  licence,
  document,
  service,

  /// Spending budget reached — only ever sent as a notification.
  budget,
}

/// Something with a date the user should act on before it passes.
class DueItem {
  final DueKind kind;
  final String vehicleId;
  final DateTime due;

  /// Set when the item comes from the Documents tab.
  final String? documentId;

  /// Set when the item comes from a service record's "next due" date.
  final String? serviceRecordId;

  /// Document title or service type, shown when [kind] alone isn't enough.
  final String? title;

  const DueItem({
    required this.kind,
    required this.vehicleId,
    required this.due,
    this.documentId,
    this.serviceRecordId,
    this.title,
  });

  /// True when it's one of the vehicle's own dates (insurance, PUC, RC) —
  /// the user can update it right from the reminder.
  bool get isVehicleDate =>
      documentId == null &&
      serviceRecordId == null &&
      (kind == DueKind.insurance ||
          kind == DueKind.puc ||
          kind == DueKind.registration);

  /// Whole days from [now] until [due]; negative once it has passed.
  int daysLeft(DateTime now) => _day(due).difference(_day(now)).inDays;

  /// Identifies this item across app runs, e.g. for notification IDs.
  String get key =>
      '${kind.name}:$vehicleId:${documentId ?? serviceRecordId ?? ''}:'
      '${_dateKey(due)}';

  /// Payload a notification carries, so tapping it opens the right place.
  String get payload => ReminderPayload(
    kind: kind,
    vehicleId: vehicleId,
    targetId: documentId ?? serviceRecordId,
  ).encode();
}

/// Where a reminder notification leads when tapped.
class ReminderPayload {
  static const prefix = 'reminder:';

  final DueKind kind;
  final String vehicleId;
  final String? targetId;

  const ReminderPayload({
    required this.kind,
    required this.vehicleId,
    this.targetId,
  });

  String encode() =>
      '$prefix${kind.name}:$vehicleId${targetId == null ? '' : ':$targetId'}';

  /// Null when [payload] isn't a reminder payload.
  static ReminderPayload? decode(String? payload) {
    if (payload == null || !payload.startsWith(prefix)) return null;
    final parts = payload.substring(prefix.length).split(':');
    if (parts.length < 2) return null;
    final kind = DueKind.values.where((k) => k.name == parts[0]).firstOrNull;
    if (kind == null) return null;
    return ReminderPayload(
      kind: kind,
      vehicleId: parts[1],
      targetId: parts.length > 2 ? parts.sublist(2).join(':') : null,
    );
  }

  /// App route that lets the user act on the reminder.
  String get route => switch (kind) {
    DueKind.service => '/service/$vehicleId',
    DueKind.budget => '/expenses/$vehicleId',
    // The vehicle's own dates open the date editor on its dashboard.
    DueKind.insurance || DueKind.puc || DueKind.registration
        when targetId == null =>
      '/garage/dashboard/$vehicleId?edit=${kind.name}',
    _ => '/documents/$vehicleId',
  };
}

/// A notification to schedule.
class PlannedReminder {
  final DueItem item;
  final int daysBefore;
  final DateTime at;

  const PlannedReminder(this.item, this.daysBefore, this.at);

  int get id => notificationId('${item.key}:$daysBefore');
}

/// Everything with a date across [vehicles], their [documents] and
/// [services], oldest first. A document with the same kind and date as one
/// of the vehicle's own dates (e.g. an insurance policy uploaded with the
/// expiry already entered on the vehicle) is listed once.
List<DueItem> dueItems({
  required List<Vehicle> vehicles,
  List<VehicleDocument> documents = const [],
  List<ServiceRecord> services = const [],
}) {
  final items = <DueItem>[];
  final seen = <String>{};

  void add(DueItem item) {
    // One entry per vehicle, kind and day for the vehicle-level kinds.
    final dedupe = item.kind == DueKind.document || item.kind == DueKind.service
        ? item.key
        : '${item.kind.name}:${item.vehicleId}:${_dateKey(item.due)}';
    if (seen.add(dedupe)) items.add(item);
  }

  for (final v in vehicles) {
    for (final (kind, date) in [
      (DueKind.insurance, v.insuranceExpiry),
      (DueKind.puc, v.pucExpiry),
      (DueKind.registration, v.regValidity),
    ]) {
      if (date != null) add(DueItem(kind: kind, vehicleId: v.id, due: date));
    }
  }

  for (final doc in documents) {
    final expiry = doc.expiryDate;
    if (expiry == null) continue;
    add(DueItem(
      kind: switch (doc.type) {
        DocumentTypes.insurance => DueKind.insurance,
        DocumentTypes.puc => DueKind.puc,
        DocumentTypes.rc => DueKind.registration,
        DocumentTypes.drivingLicence => DueKind.licence,
        _ => DueKind.document,
      },
      vehicleId: doc.vehicleId,
      due: expiry,
      documentId: doc.id,
      title: doc.title,
    ));
  }

  // Only the latest record of each service type sets its next due date.
  final latest = <String, ServiceRecord>{};
  for (final s in services) {
    final key = '${s.vehicleId}:${s.serviceType}';
    final current = latest[key];
    if (current == null || s.date.isAfter(current.date)) latest[key] = s;
  }
  for (final s in latest.values) {
    final next = s.nextDueDate;
    if (next == null) continue;
    add(DueItem(
      kind: DueKind.service,
      vehicleId: s.vehicleId,
      due: next,
      serviceRecordId: s.id,
      title: s.serviceType,
    ));
  }

  items.sort((a, b) => a.due.compareTo(b.due));
  return items;
}

/// Days before the due date to remind, per kind.
List<int> reminderDays(DueKind kind) =>
    kind == DueKind.service ? const [7, 1] : const [30, 7, 1];

/// Hour of the day reminders go out, in local time.
const reminderHour = 9;

/// Notifications for [items]: each reminder day at [reminderHour], skipping
/// times already past. Items for vehicles in [mutedVehicleIds] are skipped.
List<PlannedReminder> planReminders(
  List<DueItem> items, {
  required DateTime now,
  Set<String> mutedVehicleIds = const {},
}) => [
  for (final item in items)
    if (!mutedVehicleIds.contains(item.vehicleId))
      for (final days in reminderDays(item.kind))
        if (_at(item.due, days) case final at when at.isAfter(now))
          PlannedReminder(item, days, at),
];

DateTime _at(DateTime due, int daysBefore) =>
    DateTime(due.year, due.month, due.day - daysBefore, reminderHour);

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

String _dateKey(DateTime d) =>
    '${d.year}${d.month.toString().padLeft(2, '0')}'
    '${d.day.toString().padLeft(2, '0')}';
