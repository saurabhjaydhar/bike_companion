class BikeDocument {
  final String id;
  final String bikeId;
  final String type;
  final String title;
  final String? filePath;
  final DateTime? expiryDate;

  const BikeDocument({
    required this.id,
    required this.bikeId,
    required this.type,
    required this.title,
    this.filePath,
    this.expiryDate,
  });

  bool get isExpired => expiryDate?.isBefore(DateTime.now()) ?? false;

  int? get daysUntilExpiry => expiryDate?.difference(DateTime.now()).inDays;

  factory BikeDocument.fromMap(Map<String, dynamic> map) => BikeDocument(
        id: map['id'] as String,
        bikeId: map['bike_id'] as String,
        type: map['type'] as String,
        title: map['title'] as String,
        filePath: map['file_path'] as String?,
        expiryDate: map['expiry_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['expiry_date'] as int)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'bike_id': bikeId,
        'type': type,
        'title': title,
        'file_path': filePath,
        'expiry_date': expiryDate?.millisecondsSinceEpoch,
      };

  BikeDocument copyWith({
    String? id,
    String? bikeId,
    String? type,
    String? title,
    String? filePath,
    DateTime? expiryDate,
  }) =>
      BikeDocument(
        id: id ?? this.id,
        bikeId: bikeId ?? this.bikeId,
        type: type ?? this.type,
        title: title ?? this.title,
        filePath: filePath ?? this.filePath,
        expiryDate: expiryDate ?? this.expiryDate,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BikeDocument && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BikeDocument($id, $type, bike=$bikeId)';
}
