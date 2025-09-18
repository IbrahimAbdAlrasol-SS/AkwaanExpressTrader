import 'package:flutter/material.dart';

enum NotificationType {
  order,
  delivery,
  payment,
  system,
  promotion,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isRead = false,
  });

  // الحصول على الأيقونة حسب نوع الإشعار
  IconData get icon {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_cart_outlined;
      case NotificationType.delivery:
        return Icons.local_shipping_outlined;
      case NotificationType.payment:
        return Icons.payment_outlined;
      case NotificationType.system:
        return Icons.settings_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
    }
  }

  // الحصول على لون الأيقونة حسب نوع الإشعار
  Color get iconColor {
    switch (type) {
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.delivery:
        return Colors.green;
      case NotificationType.payment:
        return Colors.orange;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.promotion:
        return Colors.purple;
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => NotificationType.system,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return Object.hash(id, type, title, description, createdAt, isRead);
  }
}