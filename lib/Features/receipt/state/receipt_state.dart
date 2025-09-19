import '../models/receipt_update_model.dart';

/// حالة الوصولات
class ReceiptState {
  final List<ReceiptUpdateModel> receipts;
  final bool isLoading;
  final String searchQuery;
  final String? error;

  const ReceiptState({
    this.receipts = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.error,
  });

  ReceiptState copyWith({
    List<ReceiptUpdateModel>? receipts,
    bool? isLoading,
    String? searchQuery,
    String? error,
  }) {
    return ReceiptState(
      receipts: receipts ?? this.receipts,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error ?? this.error,
    );
  }

  /// الحصول على الوصولات النشطة
  List<ReceiptUpdateModel> get activeReceipts {
    return receipts.where((receipt) {
      final status = receipt.status.toLowerCase();
      return status == 'new' || 
             status == 'in_collection' || 
             status == 'in_warehouse' || 
             status == 'delayed';
    }).toList();
  }

  /// الحصول على الوصولات المكتملة
  List<ReceiptUpdateModel> get completedReceipts {
    return receipts.where((receipt) {
      return receipt.status.toLowerCase() == 'completed';
    }).toList();
  }

  /// الحصول على الوصولات الراجعة
  List<ReceiptUpdateModel> get returnedReceipts {
    return receipts.where((receipt) {
      return receipt.status.toLowerCase() == 'returned';
    }).toList();
  }

  /// تصفية الوصولات حسب البحث
  List<ReceiptUpdateModel> filterReceipts(List<ReceiptUpdateModel> receipts) {
    if (searchQuery.isEmpty) return receipts;
    
    return receipts.where((receipt) {
      return receipt.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
             receipt.location.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  /// الحصول على الوصولات النشطة المفلترة
  List<ReceiptUpdateModel> get filteredActiveReceipts => filterReceipts(activeReceipts);

  /// الحصول على الوصولات المكتملة المفلترة
  List<ReceiptUpdateModel> get filteredCompletedReceipts => filterReceipts(completedReceipts);

  /// الحصول على الوصولات الراجعة المفلترة
  List<ReceiptUpdateModel> get filteredReturnedReceipts => filterReceipts(returnedReceipts);
}