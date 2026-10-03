class Expense {
  final String id;
  final String vehicleId;
  final DateTime date;
  final String category;
  final double amount;
  final String? note;

  const Expense({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.category,
    required this.amount,
    this.note,
  });

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'] as String,
        vehicleId: map['vehicle_id'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        category: map['category'] as String,
        amount: (map['amount'] as num).toDouble(),
        note: map['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'vehicle_id': vehicleId,
        'date': date.millisecondsSinceEpoch,
        'category': category,
        'amount': amount,
        'note': note,
      };

  Expense copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    String? category,
    double? amount,
    String? note,
  }) =>
      Expense(
        id: id ?? this.id,
        vehicleId: vehicleId ?? this.vehicleId,
        date: date ?? this.date,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        note: note ?? this.note,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Expense && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Expense($id, $category, ₹$amount)';
}

class MonthSummary {
  final int year;
  final int month;
  final double total;

  const MonthSummary({
    required this.year,
    required this.month,
    required this.total,
  });
}
