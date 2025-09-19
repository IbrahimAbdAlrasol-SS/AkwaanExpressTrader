import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/receipt_state.dart';
import '../state/receipt_notifier.dart';
import '../models/receipt_update_model.dart';

final receiptProvider = StateNotifierProvider<ReceiptNotifier, ReceiptState>(
  (ref) => ReceiptNotifier(),
);
final activeReceiptsProvider = Provider<List<ReceiptUpdateModel>>((ref) {
  final state = ref.watch(receiptProvider);
  return state.filteredActiveReceipts;
  });
final completedReceiptsProvider = Provider<List<ReceiptUpdateModel>>((ref) {
  final state = ref.watch(receiptProvider);
  return state.filteredCompletedReceipts;
});
final returnedReceiptsProvider = Provider<List<ReceiptUpdateModel>>((ref) {
  final state = ref.watch(receiptProvider);
  return state.filteredReturnedReceipts;
});
final isLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(receiptProvider);
  return state.isLoading;
});
final searchQueryProvider = Provider<String>((ref) {
  final state = ref.watch(receiptProvider);
  return state.searchQuery;
});
final errorProvider = Provider<String?>((ref) {
  final state = ref.watch(receiptProvider);
  return state.error;
});
final receiptCountsProvider = Provider<Map<String, int>>((ref) {
  final state = ref.watch(receiptProvider);
  return {
    'active': state.filteredActiveReceipts.length,
    'completed': state.filteredCompletedReceipts.length,
    'returned': state.filteredReturnedReceipts.length,
    'total': state.receipts.length,
  };
});
final receiptStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final state = ref.watch(receiptProvider);
  final activeReceipts = state.activeReceipts;
  final completedReceipts = state.completedReceipts;
  final returnedReceipts = state.returnedReceipts;
  final totalAmount = state.receipts.fold<double>(
    0.0, 
    (sum, receipt) => sum + receipt.amount,
  );
  final activeAmount = activeReceipts.fold<double>(
    0.0, 
    (sum, receipt) => sum + receipt.amount,
  );
  final completedAmount = completedReceipts.fold<double>(
    0.0, 
    (sum, receipt) => sum + receipt.amount,
  );
  return {
    'totalAmount': totalAmount,
    'activeAmount': activeAmount,
    'completedAmount': completedAmount,
    'activeCount': activeReceipts.length,
    'completedCount': completedReceipts.length,
    'returnedCount': returnedReceipts.length,
    'totalCount': state.receipts.length,
  };
});