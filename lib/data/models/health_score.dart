import 'dart:ui' show Locale;

import '../../l10n/app_localizations.dart';

enum HealthGrade { excellent, good, fair, poor, critical }

enum HealthStatus { good, warning, danger }

class HealthFactor {
  /// Stable English identifier — used as a lookup key, not shown in the UI.
  final String label;
  final double points;
  final double maxPoints;
  final HealthStatus status;
  final String Function(AppLocalizations l) _message;

  const HealthFactor({
    required this.label,
    required this.points,
    required this.maxPoints,
    required this.status,
    required String Function(AppLocalizations l) message,
  }) : _message = message;

  double get ratio => maxPoints > 0 ? points / maxPoints : 0;

  String localizedMessage(AppLocalizations l) => _message(l);

  /// English message, for logs and tests.
  String get message => _message(lookupAppLocalizations(const Locale('en')));
}

class HealthScore {
  final int score;
  final HealthGrade grade;
  final List<HealthFactor> factors;

  const HealthScore({
    required this.score,
    required this.grade,
    required this.factors,
  });

  List<HealthFactor> get warnings =>
      factors.where((f) => f.status == HealthStatus.warning).toList();

  List<HealthFactor> get dangers =>
      factors.where((f) => f.status == HealthStatus.danger).toList();

  List<HealthFactor> get alerts => [...dangers, ...warnings];
}
