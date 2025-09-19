import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/receipt_update_model.dart';
import '../providers/receipt_providers.dart';
import 'new_receipt_list.dart';

/// عرض التبويبات الجديد للوصولات
class NewReceiptTabView extends ConsumerWidget {
  final TabController tabController;
  final String searchQuery;

  const NewReceiptTabView({
    super.key,
    required this.tabController,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة حالة التحميل
    final isLoading = ref.watch(isLoadingProvider);
    final error = ref.watch(errorProvider);

    // عرض مؤشر التحميل
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // عرض رسالة الخطأ
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('خطأ: $error'),
            ElevatedButton(
              onPressed: () => ref.read(receiptProvider.notifier).refresh(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: tabController,
      children: [
          // التبويب النشط
          Consumer(
            builder: (context, ref, child) {
              final activeReceipts = ref.watch(activeReceiptsProvider);
              return NewReceiptList(
                receipts: activeReceipts,
                searchQuery: searchQuery,
              );
            },
          ),
          // التبويب المكتمل
          Consumer(
            builder: (context, ref, child) {
              final completedReceipts = ref.watch(completedReceiptsProvider);
              return NewReceiptList(
                receipts: completedReceipts,
                searchQuery: searchQuery,
              );
            },
          ),
          // التبويب الراجع
          Consumer(
            builder: (context, ref, child) {
              final returnedReceipts = ref.watch(returnedReceiptsProvider);
              return NewReceiptList(
                receipts: returnedReceipts,
                searchQuery: searchQuery,
              );
            },
          ),
        ],
      );
  }
}
