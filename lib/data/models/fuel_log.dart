class FuelLog {
  final String id;
  final String vehicleId;
  final DateTime date;
  final int odometer;
  final double? litres;
  final double? amount;
  final String? fuelStation;
  final double? mileageCalculated;

  const FuelLog({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.odometer,
    this.litres,
    this.amount,
    this.fuelStation,
    this.mileageCalculated,
  });

  factory FuelLog.fromMap(Map<String, dynamic> map) => FuelLog(
        id: map['id'] as String,
        vehicleId: map['vehicle_id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        odometer: map['odometer'] as int,
        litres: map['litres'] as double?,
        amount: map['amount'] as double?,
        fuelStation: map['fuel_station'] as String?,
        mileageCalculated: map['mileage_calculated'] as double?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'vehicle_id': vehicleId,
        'date': date.millisecondsSinceEpoch,
        'odometer': odometer,
        'litres': litres,
        'amount': amount,
        'fuel_station': fuelStation,
        'mileage_calculated': mileageCalculated,
      };

  FuelLog copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    int? odometer,
    double? litres,
    double? amount,
    String? fuelStation,
    double? mileageCalculated,
  }) =>
      FuelLog(
        id: id ?? this.id,
        vehicleId: vehicleId ?? this.vehicleId,
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
  String toString() => 'FuelLog($id, vehicle=$vehicleId, odo=$odometer)';
}
