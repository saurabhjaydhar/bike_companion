class FuelLog {
  final String id;
  final String bikeId;
  final DateTime date;
  final int odometer;
  final double? litres;
  final double? amount;
  final String? fuelStation;
  final double? mileageCalculated;

  const FuelLog({
    required this.id,
    required this.bikeId,
    required this.date,
    required this.odometer,
    this.litres,
    this.amount,
    this.fuelStation,
    this.mileageCalculated,
  });

  factory FuelLog.fromMap(Map<String, dynamic> map) => FuelLog(
        id: map['id'] as String,
        bikeId: map['bike_id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        odometer: map['odometer'] as int,
        litres: map['litres'] as double?,
        amount: map['amount'] as double?,
        fuelStation: map['fuel_station'] as String?,
        mileageCalculated: map['mileage_calculated'] as double?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'bike_id': bikeId,
        'date': date.millisecondsSinceEpoch,
        'odometer': odometer,
        'litres': litres,
        'amount': amount,
        'fuel_station': fuelStation,
        'mileage_calculated': mileageCalculated,
      };

  FuelLog copyWith({
    String? id,
    String? bikeId,
    DateTime? date,
    int? odometer,
    double? litres,
    double? amount,
    String? fuelStation,
    double? mileageCalculated,
  }) =>
      FuelLog(
        id: id ?? this.id,
        bikeId: bikeId ?? this.bikeId,
        date: date ?? this.date,
        odometer: odometer ?? this.odometer,
        litres: litres ?? this.litres,
        amount: amount ?? this.amount,
        fuelStation: fuelStation ?? this.fuelStation,
        mileageCalculated: mileageCalculated ?? this.mileageCalculated,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FuelLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FuelLog($id, bike=$bikeId, odo=$odometer)';
}
