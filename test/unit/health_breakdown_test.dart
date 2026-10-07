import 'package:flutter_test/flutter_test.dart';
import 'package:garajo/core/constants/app_constants.dart';
import 'package:garajo/data/models/health_score.dart';
import 'package:garajo/features/dashboard/widgets/health_breakdown_sheet.dart';
import 'package:garajo/l10n/l10n.dart';
import 'dart:ui' show Locale;

HealthFactor _factor(String label, HealthStatus status,
        {double points = 5, String? serviceType}) =>
    HealthFactor(
      label: label,
      points: points,
      maxPoints: 20,
      status: status,
      serviceType: serviceType,
      message: (_) => '',
    );

void main() {
  test('factors in good shape have no fix', () {
    expect(fixFor(_factor('Engine Oil', HealthStatus.good)), isNull);
  });

  test('a due service opens its own service type', () {
    final fix = fixFor(_factor('Chain', HealthStatus.warning,
        serviceType: ServiceTypes.chainClean));
    expect(fix, isA<LogServiceFix>());
    expect((fix! as LogServiceFix).serviceType, ServiceTypes.chainClean);
  });

  test('a never-logged service falls back to its default type', () {
    final fix = fixFor(_factor('Engine Oil', HealthStatus.danger));
    expect((fix! as LogServiceFix).serviceType, ServiceTypes.oilChange);
  });

  test('insurance and fuel economy get their own fixes', () {
    expect(fixFor(_factor('Insurance', HealthStatus.danger)),
        isA<EditInsuranceFix>());
    expect(fixFor(_factor('Fuel Economy', HealthStatus.warning)),
        isA<LogFuelFix>());
  });

  test('factors are listed worst first', () {
    final score = HealthScore(score: 50, grade: HealthGrade.fair, factors: [
      _factor('Tyres', HealthStatus.good, points: 18),
      _factor('Battery', HealthStatus.danger, points: 2),
      _factor('Chain', HealthStatus.warning, points: 10),
    ]);
    expect(sortedFactors(score).map((f) => f.label),
        ['Battery', 'Chain', 'Tyres']);
  });

  test('every factor label has a translation', () {
    final l = lookupAppLocalizations(const Locale('hi'));
    for (final label in const [
      'Engine Oil', 'Chain', 'Air Filter', 'Brake Pads', 'Tyres',
      'Battery', 'Insurance', 'Fuel Economy',
    ]) {
      expect(l.healthFactorLabel(label), isNot(label));
    }
  });
}
