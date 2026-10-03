class VehicleDocument {
  final String id;
  final String vehicleId;
  final String type;
  final String title;
  final String? filePath;
  final DateTime? expiryDate;

  const VehicleDocument({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    this.filePath,
    this.expiryDate,
  });

  bool get isExpired => expiryDate?.isBefore(DateTime.now()) ?? false;

  int? get daysUntilExpiry => expiryDate?.difference(DateTime.now()).inDays;

  factory VehicleDocument.fromMap(Map<String, dynamic> map) => VehicleDocument(
        id: map['id'] as String,
        vehicleId: map['vehicle_id'] as String,
        type: map['type'] as String,
        title: map['title'] as String,
        filePath: map['file_path'] as String?,
        expiryDate: map['expiry_date'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['expiry_date'] as int)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'vehicle_id': vehicleId,
        'type': type,
        'title': title,
        'file_path': filePath,
        'expiry_date': expiryDate?.millisecondsSinceEpoch,
      };

  VehicleDocument copyWith({
    String? id,
    String? vehicleId,
    String? type,
    String? title,
    String? filePath,
    DateTime? expiryDate,
  }) =>
      VehicleDocument(
        id: id ?? this.id,
        vehicleId: vehicleId ?? this.vehicleId,
        type: type ?? this.type,
        title: title ?? this.title,
        filePath: filePath ?? this.filePath,
        expiryDate: expiryDate ?? this.expiryDate,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VehicleDocument && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'VehicleDocument($id, $type, vehicle=$vehicleId)';
}
