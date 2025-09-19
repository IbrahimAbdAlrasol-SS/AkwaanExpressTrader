import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/receipt_update_model.dart';
import 'receipt_state.dart';

/// مدير حالة الوصولات
class ReceiptNotifier extends StateNotifier<ReceiptState> {
  ReceiptNotifier() : super(const ReceiptState()) {
    // تحميل البيانات الأولية
    _loadInitialData();
  }

  /// تحميل البيانات الأولية
  void _loadInitialData() {
    // بيانات تجريبية للاختبار
    final sampleReceipts = [
           ReceiptUpdateModel(
        id: '1',
        status: 'طلب جديد',
        location: 'بغداد، الكرادة الشرقية',
        code: 'BGD001',
        updatedAt: DateTime.now(),
        amount: 125000.0, // 125 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 15, 14, 0), // 15/01/2025, 2:00م
      ),
      ReceiptUpdateModel(
        id: '2',
        status: 'in_collection',
        location: 'البصرة، شط العرب',
        code: 'BSR002',
        updatedAt: DateTime.now(),
        amount: 275000.0, // 275 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 16, 10, 30), // 16/01/2025, 10:30ص
      ),
      ReceiptUpdateModel(
        id: '3',
        status: 'in_warehouse',
        location: 'أربيل، عنكاوا',
        code: 'ERB003',
        updatedAt: DateTime.now(),
        amount: 180000.0, // 180 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 17, 16, 0), // 17/01/2025, 4:00م
      ),
      ReceiptUpdateModel(
        id: '4',
        status: 'completed',
        location: 'النجف الأشرف، الصحن الشريف',
        code: 'NJF004',
        updatedAt: DateTime.now(),
        amount: 350000.0, // 350 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 18, 11, 15), // 18/01/2025, 11:15ص
      ),
      ReceiptUpdateModel(
        id: '5',
        status: 'completed',
        location: 'كربلاء المقدسة، العباسية',
        code: 'KRB005',
        updatedAt: DateTime.now(),
        amount: 220000.0, // 220 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 12, 13, 45), // 12/01/2025, 1:45م
      ),
      ReceiptUpdateModel(
        id: '6',
        status: 'returned',
        location: 'الموصل، الجامعة',
        code: 'MSL006',
        updatedAt: DateTime.now(),
        amount: 95000.0, // 95 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 11, 9, 30), // 11/01/2025, 9:30ص
      ),
      ReceiptUpdateModel(
        id: '7',
        status: 'new',
        location: 'السليمانية، سيتي مول',
        code: 'SLM007',
        updatedAt: DateTime.now(),
        amount: 165000.0, // 165 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 19, 15, 20), // 19/01/2025, 3:20م
      ),
      ReceiptUpdateModel(
        id: '8',
        status: 'in_collection',
        location: 'الديوانية، الجمهورية',
        code: 'DIW008',
        updatedAt: DateTime.now(),
        amount: 140000.0, // 140 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 20, 12, 0), // 20/01/2025, 12:00م
      ),
      ReceiptUpdateModel(
        id: '9',
        status: 'in_warehouse',
        location: 'الناصرية، الحبوبي',
        code: 'NAS009',
        updatedAt: DateTime.now(),
        amount: 190000.0, // 190 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 21, 17, 30), // 21/01/2025, 5:30م
      ),
      ReceiptUpdateModel(
        id: '10',
        status: 'completed',
        location: 'الحلة، المدحتية',
        code: 'HIL010',
        updatedAt: DateTime.now(),
        amount: 310000.0, // 310 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 10, 8, 45), // 10/01/2025, 8:45ص
      ),
      ReceiptUpdateModel(
        id: '11',
        status: 'new',
        location: 'دهوك، زاخو',
        code: 'DHK011',
        updatedAt: DateTime.now(),
        amount: 205000.0, // 205 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 22, 14, 15), // 22/01/2025, 2:15م
      ),
      ReceiptUpdateModel(
        id: '12',
        status: 'new',
        location: 'كركوك، الواسطي',
        code: 'KRK012',
        updatedAt: DateTime.now(),
        amount: 285000.0, // 285 ألف دينار عراقي
        deliveryTime: DateTime(2025, 1, 23, 16, 45), // 23/01/2025, 4:45م
      ),
    ];

    state = state.copyWith(
      receipts: sampleReceipts,
      isLoading: false,
    );
  }
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
  void addReceipt(ReceiptUpdateModel receipt) {
    state = state.copyWith(
      receipts: [...state.receipts, receipt],
    );
  }
  /// تحديث وصولة موجودة
  void updateReceipt(ReceiptUpdateModel updatedReceipt) {
    final updatedReceipts = state.receipts.map<ReceiptUpdateModel>((receipt) {
      return receipt.id == updatedReceipt.id ? updatedReceipt : receipt;
    }).toList();

    state = state.copyWith(receipts: updatedReceipts);
  }

  /// حذف وصولة
  void deleteReceipt(String receiptId) {
    final updatedReceipts = state.receipts
        .where((receipt) => receipt.id != receiptId)
        .toList();

    state = state.copyWith(receipts: updatedReceipts);
  }

  /// تحديث حالة الوصولة
  void updateReceiptStatus(String receiptId, String newStatus) {
    final updatedReceipts = state.receipts.map<ReceiptUpdateModel>((receipt) {
      if (receipt.id == receiptId) {
        return receipt.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );
      }
      return receipt;
    }).toList();

    state = state.copyWith(receipts: updatedReceipts);
  }

  /// إعادة تحميل البيانات
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    
    // محاكاة تحميل البيانات من API
    await Future.delayed(const Duration(seconds: 1));
    
    _loadInitialData();
  }

  /// تنظيف البحث
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  /// تعيين حالة الخطأ
  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  /// مسح الخطأ
  void clearError() {
    state = state.copyWith(error: null);
  }
}