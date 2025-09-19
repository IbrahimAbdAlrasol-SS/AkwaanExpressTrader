import 'package:Tosell/Features/receipt/widgets/receipt_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/receipt_tabs_widget.dart';
import '../widgets/new_receipt_tab_view.dart';
import '../widgets/search_bar_widget.dart';
import '../providers/receipt_providers.dart';

class ReceiptScreen extends ConsumerStatefulWidget {
  const ReceiptScreen({super.key});

  @override
  ConsumerState<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends ConsumerState<ReceiptScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // التبويبات
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReceiptTabsWidget(tabController: _tabController),
            ),
            // شريط البحث
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SearchBarWidget(
                searchController: _searchController,
                onSearchChanged: _handleSearchChanged,
                onSearchTap: _handleSearchTap,
                onFilterPressed: _handleFilterPressed,
              ),
            ),
            // محتوى التبويبات
            Expanded(
              child: NewReceiptTabView(
                tabController: _tabController,
                searchQuery: _searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
    // تحديث استعلام البحث في StateNotifier
    ref.read(receiptProvider.notifier).updateSearchQuery(value);
  }

  void _handleSearchTap() {
    // معالجة النقر على حقل البحث
    // يمكن إضافة منطق إضافي هنا
  }

  void _handleFilterPressed() {
    // معالجة النقر على زر الفلتر
    // يمكن إضافة منطق الفلترة هنا
  }
}
