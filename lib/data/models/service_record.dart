class ServiceRecord {
  final String id;
  final String bikeId;
  final DateTime date;
  final String serviceType;
  final int odometer;
  final double? cost;
  final String? notes;
  final int? nextDueKm;
  final DateTime? nextDueDate;

  const ServiceRecord({
    required this.id,
    required this.bikeId,
    required this.date,
    required this.serviceType,
    required this.odometer,
    this.cost,
    this.notes,
    this.nextDueKm,
    this.nextDueDate,
  });

  factory ServiceRecord.fromMap(Map<String, dynamic> map) => ServiceRecord(
        id: map['id'] as String,
        bikeId: map['bike_id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        serviceType: map['service_type'] as String,
        odometer: map['odometer'] as int,
        cost: map['cost'] as double?,
        notes: map['notes'] as String?,
        nextDueKm: map['next_due_km'] as int?,
        nextDueDate: map['next_due_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['next_due_date'] as int)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'bike_id': bikeId,
        'date': date.millisecondsSinceEpoch,
        'service_type': serviceType,
        'odometer': odometer,
        'cost': cost,
        'notes': notes,
        'next_due_km': nextDueKm,
        'next_due_date': nextDueDate?.millisecondsSinceEpoch,
      };

  ServiceRecord copyWith({
    String? id,
    String? bikeId,
    DateTime? date,
    String? serviceType,
    int? odometer,
    double? cost,
    String? notes,
    int? nextDueKm,
    DateTime? nextDueDate,
  }) =>
      ServiceRecord(
        id: id ?? this.id,
        bikeId: bikeId ?? this.bikeId,
        date: date ?? this.date,
        serviceType: serviceType ?? this.serviceType,
        odometer: odometer ?? this.odometer,
        cost: cost ?? this.cost,
        notes: notes ?? this.notes,
        nextDueKm: nextDueKm ?? this.nextDueKm,
        nextDueDate: nextDueDate ?? this.nextDueDate,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ServiceRecord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ServiceRecord($id, $serviceType, bike=$bikeId)';
}
