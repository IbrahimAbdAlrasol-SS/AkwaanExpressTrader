import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/receipt_update_model.dart';
import '../enums/receipt_status.dart';
import '../providers/receipt_providers.dart';
import 'new_receipt_list.dart';

/// محتوى التبويبات الجديد للوصولات
class NewReceiptTabContent {
  /// بناء تبويب الوصولات النشطة
  static Widget buildActiveReceipts(List<ReceiptUpdateModel> receipts,
      {String searchQuery = ''}) {
    // فلترة الوصولات النشطة
    final activeReceipts = receipts.where((receipt) {
      final status = ReceiptStatus.fromString(receipt.status);
      return status.isActive;
    }).toList();

    return NewReceiptList(
      receipts: activeReceipts,
      searchQuery: searchQuery,
    );
  }
  static Widget buildCompletedReceipts(List<ReceiptUpdateModel> receipts,
      {String searchQuery = ''}) {
    // فلترة الوصولات المكتملة
    final completedReceipts = receipts.where((receipt) {
      final status = ReceiptStatus.fromString(receipt.status);
      return status.isCompleted;
    }).toList();

    return NewReceiptList(
      receipts: completedReceipts,
      searchQuery: searchQuery,
    );
  }  static Widget buildReturnedReceipts(List<ReceiptUpdateModel> receipts,
      {String searchQuery = ''}) {
    final returnedReceipts = receipts.where((receipt) {
      final status = ReceiptStatus.fromString(receipt.status);
      return status.isReturned;
    }).toList();
    return NewReceiptList(
      receipts: returnedReceipts,
      searchQuery: searchQuery,
    );
  }
  /// إنشاء بيانات تجريبية عراقية واقعية للاختبار

}
