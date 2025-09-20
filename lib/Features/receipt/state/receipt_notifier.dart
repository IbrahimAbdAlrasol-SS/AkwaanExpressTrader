import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/receipt_update_model.dart';
import 'receipt_state.dart';

/// مدير حالة الوصولات
class ReceiptNotifier extends StateNotifier<ReceiptState> {
  ReceiptNotifier() : super(const ReceiptState()) {
    // تحميل البيانات الأولية
    _loadInitialData();
  }

  /// تحميل البيانات الأولية من API
  Future<void> _loadInitialData() async {
    try {
      // جلب البيانات من API
      final receipts = await _fetchReceiptsFromAPI();

      state = state.copyWith(
        receipts: receipts,
        isLoading: false,
      );
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
      state = state.copyWith(
        receipts: [],
        isLoading: false,
      );
    }
  }

  /// جلب الإيصالات من API
  Future<List<ReceiptUpdateModel>> _fetchReceiptsFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.akwaanexpress.com/api/receipts'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> receiptsJson = data['data'] ?? [];
        return receiptsJson
            .map((json) => ReceiptUpdateModel.fromJson(json))
            .toList();
      } else {
        print('خطأ في جلب الإيصالات: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('خطأ في الاتصال بالخادم: $e');
      return [];
    }
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
    final updatedReceipts =
        state.receipts.where((receipt) => receipt.id != receiptId).toList();

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
