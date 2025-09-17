class ReceiptUpdateModel {
  final String id;
  final String status;
  final String location;
  final String code;
  final DateTime updatedAt;

  const ReceiptUpdateModel({
    required this.id,
    required this.status,
    required this.location,
    required this.code,
    required this.updatedAt,
  });

  factory ReceiptUpdateModel.fromJson(Map<String, dynamic> json) {
    return ReceiptUpdateModel(
      id: json['id'] as String,
      status: json['status'] as String,
      location: json['location'] as String,
      code: json['code'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'location': location,
      'code': code,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReceiptUpdateModel &&
        other.id == id &&
        other.status == status &&
        other.location == location &&
        other.code == code &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, status, location, code, updatedAt);
  }

  @override
  String toString() {
    return 'ReceiptUpdateModel(id: $id, status: $status, location: $location, code: $code, updatedAt: $updatedAt)';
  }
}
