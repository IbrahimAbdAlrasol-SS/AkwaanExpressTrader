class ReceiptUpdateModel {
  final String id;
  final String status;
  final String location;
  final String code;
  final DateTime updatedAt;
  final double amount; // مبلغ الاستحقاق
  final DateTime deliveryTime; // وقت التسليم

  const ReceiptUpdateModel({
    required this.id,
    required this.status,
    required this.location,
    required this.code,
    required this.updatedAt,
    required this.amount,
    required this.deliveryTime,
  });

  factory ReceiptUpdateModel.fromJson(Map<String, dynamic> json) {
    return ReceiptUpdateModel(
      id: json['id'] as String,
      status: json['status'] as String,
      location: json['location'] as String,
      code: json['code'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      amount: (json['amount'] as num).toDouble(),
      deliveryTime: DateTime.parse(json['deliveryTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'location': location,
      'code': code,
      'updatedAt': updatedAt.toIso8601String(),
      'amount': amount,
      'deliveryTime': deliveryTime.toIso8601String(),
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
        other.updatedAt == updatedAt &&
        other.amount == amount &&
        other.deliveryTime == deliveryTime;
  }

  @override
  int get hashCode {
    return Object.hash(
        id, status, location, code, updatedAt, amount, deliveryTime);
  }

  /// إنشاء نسخة محدثة من النموذج
  ReceiptUpdateModel copyWith({
    String? id,
    String? status,
    String? location,
    String? code,
    DateTime? updatedAt,
    double? amount,
    DateTime? deliveryTime,
  }) {
    return ReceiptUpdateModel(
      id: id ?? this.id,
      status: status ?? this.status,
      location: location ?? this.location,
      code: code ?? this.code,
      updatedAt: updatedAt ?? this.updatedAt,
      amount: amount ?? this.amount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
    );
  }

  @override
  String toString() {
    return 'ReceiptUpdateModel(id: $id, status: $status, location: $location, code: $code, updatedAt: $updatedAt, amount: $amount, deliveryTime: $deliveryTime)';
  }
}
