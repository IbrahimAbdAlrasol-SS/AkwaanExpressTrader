import 'package:flutter/material.dart';
import '../models/receipt_update_model.dart';
import '../enums/receipt_status.dart';
import 'receipt_item_widget.dart';
import 'receipt_item_card.dart';

/// ويدجت قائمة الوصولات الجديدة
class NewReceiptList extends StatelessWidget {
  final List<ReceiptUpdateModel> receipts;
  final String searchQuery;

  const NewReceiptList({
    super.key,
    required this.receipts,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // قائمة الوصولات
        Expanded(
          child: receipts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: receipts.length,
                  itemBuilder: (context, index) {
                    return ReceiptItemCard(
                      receipt: receipts[index],
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty
                ? 'لا توجد نتائج للبحث'
                : 'لا توجد وصولات',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'جرب البحث بكلمات مختلفة',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
