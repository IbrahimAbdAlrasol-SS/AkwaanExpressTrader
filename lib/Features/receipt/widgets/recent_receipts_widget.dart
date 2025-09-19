import 'package:flutter/material.dart';
import '../models/receipt_update_model.dart';
import 'receipt_item_widget.dart';

class RecentReceiptsWidget extends StatelessWidget {
  final List<ReceiptUpdateModel> receipts;
  final int maxDisplayCount;
  final VoidCallback? onViewMore;
  final Function(ReceiptUpdateModel)? onReceiptTap;

  const RecentReceiptsWidget({
    super.key,
    required this.receipts,
    this.maxDisplayCount = 3,
    this.onViewMore,
    this.onReceiptTap,
  });

  @override
  Widget build(BuildContext context) {

    final sortedReceipts = List<ReceiptUpdateModel>.from(receipts)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'آخر تحديثات الوصولات',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 15,
                ),
          ),
        ),
        // العرض الديناميكي حسب عدد العناصر
        _buildDynamicDisplay(sortedReceipts, context),
      ],
    );
  }

  Widget _buildDynamicDisplay(
      List<ReceiptUpdateModel> sortedReceipts, BuildContext context) {
    final receiptCount = sortedReceipts.length;

    // إذا القائمة فارغة → يظهر "لا يوجد وصولات"
    if (receiptCount == 0) {
      return _buildEmptyState(context);
    }

    // إذا فيها عنصر واحد → يعرض صف واحد
    else if (receiptCount == 1) {
      return _buildSingleReceipt(sortedReceipts.first, context);
    }

    // إذا فيها عنصران → صفين مدمجين
    else if (receiptCount == 2) {
      return _buildTwoReceipts(sortedReceipts.take(2).toList(), context);
    }

    // إذا فيها ثلاثة أو أكثر → يعرض أول 3 فقط مدمجين + زر "عرض المزيد (+N)"
    else {
      final displayReceipts = sortedReceipts.take(maxDisplayCount).toList();
      final remainingCount = receiptCount - maxDisplayCount;
      return _buildMultipleReceipts(displayReceipts, remainingCount, context);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'لا يوجد وصولات',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  // عرض عنصر واحد فقط
  Widget _buildSingleReceipt(ReceiptUpdateModel receipt, BuildContext context) {
    return ReceiptItemWidget(
      receipt: receipt,
      onTap: () => onReceiptTap?.call(receipt),
      isFirst: true,
      isLast: true,
    );
  }

  // عرض عنصرين مدمجين
  Widget _buildTwoReceipts(
      List<ReceiptUpdateModel> receipts, BuildContext context) {
    return Column(
      children: receipts.asMap().entries.map((entry) {
        final index = entry.key;
        final receipt = entry.value;
        return ReceiptItemWidget(
          receipt: receipt,
          onTap: () => onReceiptTap?.call(receipt),
          isFirst: index == 0,
          isLast: index == receipts.length - 1,
        );
      }).toList(),
    );
  }

  // عرض متعدد مع زر "عرض المزيد"
  Widget _buildMultipleReceipts(
    List<ReceiptUpdateModel> displayReceipts,
    int remainingCount,
    BuildContext context,
  ) {
    return Column(
      children: [
        // عرض الوصولات المحددة (أول 3 مدمجين)
        ...displayReceipts.asMap().entries.map((entry) {
          final index = entry.key;
          final receipt = entry.value;
          return ReceiptItemWidget(
            receipt: receipt,
            onTap: () => onReceiptTap?.call(receipt),
            isFirst: index == 0,
            isLast: index == displayReceipts.length - 1,
          );
        }).toList(),
      ],
    );
  }
}
