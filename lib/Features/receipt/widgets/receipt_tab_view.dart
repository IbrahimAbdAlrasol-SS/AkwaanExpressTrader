import 'package:flutter/material.dart';
import 'receipt_tab_content.dart';

class ReceiptTabView extends StatelessWidget {
  final TabController tabController;

  const ReceiptTabView({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: tabController,
        children: [
          ReceiptTabContent.buildActiveReceipts(),
          ReceiptTabContent.buildCompletedReceipts(),
          ReceiptTabContent.buildReturnedReceipts(),
        ],
      ),
    );
  }
}
