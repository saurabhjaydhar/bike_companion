enum HealthGrade { excellent, good, fair, poor, critical }

enum HealthStatus { good, warning, danger }

class HealthFactor {
  final String label;
  final double points;
  final double maxPoints;
  final HealthStatus status;
  final String message;

  const HealthFactor({
    required this.label,
    required this.points,
    required this.maxPoints,
    required this.status,
    required this.message,
  });

  double get ratio => maxPoints > 0 ? points / maxPoints : 0;
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

  String get gradeLabel {
    switch (grade) {
      case HealthGrade.excellent: return 'Excellent condition';
      case HealthGrade.good:      return 'Good condition';
      case HealthGrade.fair:      return 'Fair condition';
      case HealthGrade.poor:      return 'Needs attention';
      case HealthGrade.critical:  return 'Critical — service now';
    }
  }

  List<HealthFactor> get warnings =>
      factors.where((f) => f.status == HealthStatus.warning).toList();

  List<HealthFactor> get dangers =>
      factors.where((f) => f.status == HealthStatus.danger).toList();

  List<HealthFactor> get alerts => [...dangers, ...warnings];
}
