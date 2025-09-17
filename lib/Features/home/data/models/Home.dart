class Home {
  final String? id;
  final String? name;
  final String? description;
  final int? totalOrders;
  final double? totalRevenue;
  final int? pendingOrders;
  final int? completedOrders;

  const Home({
    this.id,
    this.name,
    this.description,
    this.totalOrders,
    this.totalRevenue,
    this.pendingOrders,
    this.completedOrders,
  });

  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      totalOrders: json['totalOrders'] as int?,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble(),
      pendingOrders: json['pendingOrders'] as int?,
      completedOrders: json['completedOrders'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'pendingOrders': pendingOrders,
      'completedOrders': completedOrders,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Home &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.totalOrders == totalOrders &&
        other.totalRevenue == totalRevenue &&
        other.pendingOrders == pendingOrders &&
        other.completedOrders == completedOrders;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      totalOrders,
      totalRevenue,
      pendingOrders,
      completedOrders,
    );
  }

  @override
  String toString() {
    return 'Home(id: $id, name: $name, description: $description, totalOrders: $totalOrders, totalRevenue: $totalRevenue, pendingOrders: $pendingOrders, completedOrders: $completedOrders)';
  }
}