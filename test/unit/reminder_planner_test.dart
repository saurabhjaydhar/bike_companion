import 'package:bike_companion/core/constants/app_constants.dart';
import 'package:bike_companion/core/services/reminder_planner.dart';
import 'package:bike_companion/data/models/document.dart';
import 'package:bike_companion/data/models/service_record.dart';
import 'package:bike_companion/data/models/vehicle.dart';
import 'package:flutter_test/flutter_test.dart';

Vehicle vehicle(
  String id, {
  DateTime? insurance,
  DateTime? puc,
  DateTime? registration,
}) => Vehicle(
  id: id,
  name: 'Bullet',
  brand: 'Royal Enfield',
  model: 'Classic 350',
  colourHex: '#1A56DB',
  regNumber: 'MH12DE1234',
  odometerCurrent: 1000,
  odometerOfficial: 1000,
  createdAt: DateTime(2024),
  insuranceExpiry: insurance,
  pucExpiry: puc,
  regValidity: registration,
);

VehicleDocument doc(String id, String type, DateTime? expiry) =>
    VehicleDocument(
      id: id,
      vehicleId: 'v1',
      type: type,
      title: 'Policy',
      expiryDate: expiry,
    );

ServiceRecord service(String id, DateTime date, {DateTime? nextDue}) =>
    ServiceRecord(
      id: id,
      vehicleId: 'v1',
      date: date,
      serviceType: ServiceTypes.oilChange,
      odometer: 1000,
      nextDueDate: nextDue,
    );

void main() {
  final now = DateTime(2026, 3, 1, 12);

  group('dueItems', () {
    test('collects vehicle dates, documents and service due dates', () {
      final items = dueItems(
        vehicles: [
          vehicle('v1',
              insurance: DateTime(2026, 6, 1),
              puc: DateTime(2026, 4, 1),
              registration: DateTime(2040, 1, 1)),
        ],
        documents: [doc('d1', DocumentTypes.drivingLicence, DateTime(2027))],
        services: [
          service('s1', DateTime(2026, 1, 1), nextDue: DateTime(2026, 5, 1)),
        ],
      );
      expect(items.map((i) => i.kind), [
        DueKind.puc, // sorted by due date
        DueKind.service,
        DueKind.insurance,
        DueKind.licence,
        DueKind.registration,
      ]);
    });

    test('lists a document once when the vehicle has the same date', () {
      final items = dueItems(
        vehicles: [vehicle('v1', insurance: DateTime(2026, 6, 1))],
        documents: [
          doc('d1', DocumentTypes.insurance, DateTime(2026, 6, 1, 18)),
          // Different date: a different policy, kept.
          doc('d2', DocumentTypes.insurance, DateTime(2027, 6, 1)),
        ],
      );
      expect(items, hasLength(2));
      expect(items.first.isVehicleDate, isTrue);
      expect(items.last.documentId, 'd2');
    });

    test('uses only the latest record of a service type', () {
      final items = dueItems(
        vehicles: const [],
        services: [
          service('old', DateTime(2025, 1, 1), nextDue: DateTime(2025, 7, 1)),
          service('new', DateTime(2026, 1, 1), nextDue: DateTime(2026, 7, 1)),
        ],
      );
      expect(items.single.serviceRecordId, 'new');
    });

    test('ignores documents without an expiry', () {
      expect(
        dueItems(vehicles: const [], documents: [doc('d', 'other', null)]),
        isEmpty,
      );
    });
  });

  group('planReminders', () {
    test('reminds 30, 7 and 1 day before, at 9 AM', () {
      final item = DueItem(
          kind: DueKind.insurance, vehicleId: 'v1', due: DateTime(2026, 6, 1));
      final plan = planReminders([item], now: now);
      expect(plan.map((p) => p.at), [
        DateTime(2026, 5, 2, 9),
        DateTime(2026, 5, 25, 9),
        DateTime(2026, 5, 31, 9),
      ]);
    });

    test('reminds about services 7 and 1 day before', () {
      final item = DueItem(
          kind: DueKind.service, vehicleId: 'v1', due: DateTime(2026, 6, 1));
      expect(planReminders([item], now: now).map((p) => p.daysBefore), [7, 1]);
    });

    test('skips reminder times already past', () {
      // Due in 5 days: only the 1-day reminder is still ahead.
      final item = DueItem(
          kind: DueKind.puc, vehicleId: 'v1', due: DateTime(2026, 3, 6));
      expect(planReminders([item], now: now).map((p) => p.daysBefore), [1]);
      // Today's 9 AM reminder has passed by noon.
      final tomorrow = DueItem(
          kind: DueKind.puc, vehicleId: 'v1', due: DateTime(2026, 3, 2));
      expect(planReminders([tomorrow], now: now), isEmpty);
    });

    test('skips muted vehicles', () {
      final item = DueItem(
          kind: DueKind.puc, vehicleId: 'v1', due: DateTime(2026, 6, 1));
      expect(planReminders([item], now: now, mutedVehicleIds: {'v1'}), isEmpty);
    });

    test('gives each reminder a distinct, repeatable ID', () {
      final item = DueItem(
          kind: DueKind.puc, vehicleId: 'v1', due: DateTime(2026, 6, 1));
      final a = planReminders([item], now: now).map((p) => p.id).toList();
      final b = planReminders([item], now: now).map((p) => p.id).toList();
      expect(a, b);
      expect(a.toSet(), hasLength(3));
    });
  });

  group('ReminderPayload', () {
    test('round-trips and opens the right screen', () {
      final insurance = DueItem(
          kind: DueKind.insurance, vehicleId: 'v1', due: DateTime(2026));
      final parsed = ReminderPayload.decode(insurance.payload)!;
      expect(parsed.kind, DueKind.insurance);
      expect(parsed.route, '/garage/dashboard/v1?edit=insurance');

      final policy = DueItem(
          kind: DueKind.insurance,
          vehicleId: 'v1',
          due: DateTime(2026),
          documentId: 'd1');
      expect(ReminderPayload.decode(policy.payload)!.route, '/documents/v1');

      final service = DueItem(
          kind: DueKind.service,
          vehicleId: 'v1',
          due: DateTime(2026),
          serviceRecordId: 's1');
      expect(ReminderPayload.decode(service.payload)!.route, '/service/v1');
    });

    test('ignores other payloads', () {
      expect(ReminderPayload.decode(null), isNull);
      expect(ReminderPayload.decode('doc_reminder'), isNull);
      expect(ReminderPayload.decode('reminder:unknown:v1'), isNull);
    });
  });

  test('daysLeft counts calendar days', () {
    final item = DueItem(
        kind: DueKind.puc, vehicleId: 'v1', due: DateTime(2026, 3, 2, 8));
    expect(item.daysLeft(now), 1);
    expect(item.daysLeft(DateTime(2026, 3, 3)), -1);
  });
}
