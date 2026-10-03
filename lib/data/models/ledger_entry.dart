/// Where a ledger entry comes from.
enum LedgerSource { expense, fuel, service }

/// One amount spent on a vehicle: an expense, a fuel fill-up or a service.
/// Built at query time from the three tables — nothing is copied, so a
/// fill-up is never counted twice.
class LedgerEntry {
  final String id;
  final String vehicleId;
  final DateTime date;

  /// An [ExpenseCategories] key; fuel logs are 'fuel', services 'service'.
  final String category;
  final double amount;

  /// Expense note, fuel station, or service type key.
  final String? note;
  final LedgerSource source;

  const LedgerEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.category,
    required this.amount,
    required this.source,
    this.note,
  });

  factory LedgerEntry.fromMap(Map<String, dynamic> map) => LedgerEntry(
    id: map['id'] as String,
    vehicleId: map['vehicle_id'] as String,
    date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    category: map['category'] as String,
    amount: (map['amount'] as num).toDouble(),
    note: map['note'] as String?,
    source: LedgerSource.values.byName(map['source'] as String),
  );
}

/// An odometer reading, from a fuel log or a service record.
class OdometerReading {
  final DateTime date;
  final int km;

  const OdometerReading(this.date, this.km);
}
