import 'package:bike_companion/core/constants/app_constants.dart';
import 'package:bike_companion/core/services/reminder_planner.dart';
import 'package:bike_companion/data/models/health_score.dart';
import 'package:bike_companion/data/models/vehicle.dart';
import 'package:bike_companion/features/dashboard/dashboard_provider.dart';
import 'package:bike_companion/features/dashboard/widgets/coming_up_card.dart';
import 'package:bike_companion/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.now();

Vehicle _vehicle({DateTime? insurance, DateTime? puc}) => Vehicle(
  id: 'v1',
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
);

DashboardState _dash({
  required Vehicle vehicle,
  List<HealthFactor> factors = const [],
  bool permitted = true,
}) => DashboardState(
  vehicle: vehicle,
  allVehicles: [vehicle],
  healthScore: HealthScore(
    score: 80,
    grade: HealthGrade.good,
    factors: factors,
  ),
  lastFuelLog: null,
  avgMileage: null,
  nextService: null,
  monthTotal: 0,
  costPerKm: null,
  budgetSuggestion: null,
  recentActivity: const [],
  dueItems: dueItems(vehicles: [vehicle]),
  remindersPermitted: permitted,
  remindersMuted: false,
);

Future<void> _pump(
  WidgetTester tester,
  DashboardState dash, {
  void Function(DueKind)? onEdit,
  VoidCallback? onTurnOn,
}) => tester.pumpWidget(MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: ComingUpCard(
      dash: dash,
      onEditDate: onEdit ?? (_) {},
      onTurnOnReminders: onTurnOn ?? () {},
    ),
  ),
));

List<String> _labelsTopToBottom(WidgetTester tester, List<String> labels) {
  final found = [
    for (final l in labels)
      if (find.text(l).evaluate().isNotEmpty) (l, tester.getTopLeft(find.text(l)).dy),
  ]..sort((a, b) => a.$2.compareTo(b.$2));
  return [for (final f in found) f.$1];
}

void main() {
  testWidgets('lists the most urgent item first', (tester) async {
    final vehicle = _vehicle(
      insurance: _now.add(const Duration(days: 200)),
      puc: _now.add(const Duration(days: 3)),
    );
    final oil = HealthFactor(
      label: 'Engine Oil',
      points: 10,
      maxPoints: 20,
      status: HealthStatus.warning,
      serviceType: ServiceTypes.oilChange,
      message: (l) => l.healthOilDue(500),
    );
    await _pump(tester, _dash(vehicle: vehicle, factors: [oil]));

    // PUC in 3 days (red) → oil change soon (amber) → insurance (green).
    expect(
      _labelsTopToBottom(tester, ['PUC Certificate', 'Oil Change', 'Insurance']),
      ['PUC Certificate', 'Oil Change', 'Insurance'],
    );
    expect(find.text('in 3 days'), findsOneWidget);
  });

  testWidgets('prompts for missing insurance and PUC dates', (tester) async {
    DueKind? edited;
    await _pump(tester, _dash(vehicle: _vehicle()), onEdit: (k) => edited = k);
    expect(find.text('Add date'), findsNWidgets(2));
    await tester.tap(find.text('Insurance'));
    expect(edited, DueKind.insurance);
  });

  testWidgets('says when nothing is due', (tester) async {
    final vehicle = _vehicle(
      insurance: _now.add(const Duration(days: 300)),
      puc: _now.add(const Duration(days: 300)),
    );
    final dash = _dash(vehicle: vehicle);
    // Nothing urgent: the far-off dates still show, as green entries.
    await _pump(tester, dash);
    expect(find.text('Insurance'), findsOneWidget);

    await _pump(
      tester,
      DashboardState(
        vehicle: vehicle,
        allVehicles: [vehicle],
        healthScore: dash.healthScore,
        lastFuelLog: null,
        avgMileage: null,
        nextService: null,
        monthTotal: 0,
        costPerKm: null,
        budgetSuggestion: null,
        recentActivity: const [],
        dueItems: const [],
        remindersPermitted: true,
        remindersMuted: false,
      ),
    );
    expect(find.textContaining('nothing due soon'), findsOneWidget);
  });

  testWidgets('offers to turn reminders on when blocked', (tester) async {
    var asked = false;
    await _pump(
      tester,
      _dash(vehicle: _vehicle(), permitted: false),
      onTurnOn: () => asked = true,
    );
    await tester.tap(find.text('Turn on'));
    expect(asked, isTrue);
  });
}
