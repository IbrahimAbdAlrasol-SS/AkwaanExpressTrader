import 'package:flutter/material.dart';

/// تعداد حالات الوصولات مع الألوان المخصصة لكل حالة
enum ReceiptStatus {
  newOrder('طلب جديد'),
  inCollection('قيد استحصال'),
  inWarehouse('في المخزن'),
  delayed('مؤجل'),
  completed('مكتملة'),
  returned('راجع');

  const ReceiptStatus(this.displayName);

  final String displayName;

  /// لون خلفية الحالة
  Color get backgroundColor {
    switch (this) {
      case ReceiptStatus.newOrder:
        return const Color(0xFFF0F8FF);
      case ReceiptStatus.inCollection:
        return const Color(0xFFFDFDF6);
      case ReceiptStatus.inWarehouse:
        return const Color(0xFFF0F8FF);
      case ReceiptStatus.delayed:
        return const Color(0xFFFFFBFA);
      case ReceiptStatus.completed:
        return const Color(0xFFE7FFE7);
      case ReceiptStatus.returned:
        return const Color(0xFFFFFBFA);
    }
  }

  /// لون نص الحالة
  Color get textColor {
    switch (this) {
      case ReceiptStatus.newOrder:
        return const Color(0xFF47A2FF);
      case ReceiptStatus.inCollection:
        return const Color(0xFFDDC73C);
      case ReceiptStatus.inWarehouse:
        return const Color(0xFF47A2FF);
      case ReceiptStatus.delayed:
        return const Color(0xFFF15B28);
      case ReceiptStatus.completed:
        return const Color(0xFF00A86B);
      case ReceiptStatus.returned:
        return const Color(0xFFF15B28);
    }
  }

  /// تحويل النص إلى enum
  static ReceiptStatus fromString(String status) {
    switch (status.toLowerCase()) {
      // النصوص العربية
      case 'طلب جديد':
        return ReceiptStatus.newOrder;
      case 'قيد استحصال':
        return ReceiptStatus.inCollection;
      case 'في المخزن':
        return ReceiptStatus.inWarehouse;
      case 'مؤجل':
        return ReceiptStatus.delayed;
      case 'مكتملة':
        return ReceiptStatus.completed;
      case 'راجع':
        return ReceiptStatus.returned;
      // النصوص الإنجليزية للبيانات التجريبية
      case 'new':
        return ReceiptStatus.newOrder;
      case 'in_collection':
        return ReceiptStatus.inCollection;
      case 'in_warehouse':
        return ReceiptStatus.inWarehouse;
      case 'delayed':
        return ReceiptStatus.delayed;
      case 'completed':
        return ReceiptStatus.completed;
      case 'returned':
        return ReceiptStatus.returned;
      default:
        return ReceiptStatus.newOrder;
    }
  }

  /// التحقق من كون الحالة نشطة (تظهر في تاب النشطة)
  bool get isActive {
    return this == ReceiptStatus.newOrder ||
        this == ReceiptStatus.inCollection ||
        this == ReceiptStatus.inWarehouse ||
        this == ReceiptStatus.delayed;
  }

  /// التحقق من كون الحالة مكتملة
  bool get isCompleted {
    return this == ReceiptStatus.completed;
  }

  /// التحقق من كون الحالة راجعة
  bool get isReturned {
    return this == ReceiptStatus.returned;
  }
}
