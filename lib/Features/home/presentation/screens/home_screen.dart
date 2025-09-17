import 'package:Tosell/Features/home/data/models/Home.dart';
import 'package:Tosell/Features/home/presentation/providers/home_provider.dart';
import 'package:Tosell/Features/profile/providers/profile_provider.dart';
import 'package:Tosell/Features/profile/screens/myProfile_Screen.dart';
import 'package:Tosell/Features/receipt/widgets/recent_receipts_widget.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/Others/build_cart.dart';
import 'package:Tosell/Features/home/presentation/providers/home_provider.dart'
    hide homeNotifierProvider;
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/notification/screens/notification_screen.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/action_counter_widget.dart';
import '../widgets/comprehensive_statistics_widget.dart';
import '../widgets/financial_summary_widget.dart';
import 'package:Tosell/Features/receipt/models/receipt_update_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var homeState = ref.watch(homeNotifierProvider);
    var userState = ref.watch(profileNotifierProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.4, 0.4, 1.0],
              colors: [
                Color(0xFF1A66FF), // لون الجزء العلوي
                Color(0xFF134AB9), // نهاية الجزء العلوي
                Colors.white, // بداية الجزء السفلي الأبيض
                Colors.white, // نهاية الجزء السفلي الأبيض
              ],
            ),
          ),
          child: homeState.when(
            data: (data) =>
                _buildUi(context, user: userState.value ?? User(), home: data),
            error: (error, _) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _buildUi(BuildContext context,
      {required User user, required Home home}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(15),
          HomeHeaderWidget(
            user: user,
            home: home,
          ),
          const FinancialSummaryWidget(
            receivablesAmount: '200,000',
            debtsAmount: '50,000',
          ),
          const Gap(10),
          ActionCounterWidget(
            onAddReceiptTap: () {
              print('تم الضغط على إضافة وصل');
            },
            onWithdrawBalanceTap: () {
              print('تم الضغط على سحب رصيد');
            },
            onInvoiceHistoryTap: () {
              print('تم الضغط على سجل الفواتير');
            },
          ),
          const Gap(10),
          const ComprehensiveStatisticsWidget(),
          const Gap(16),
          RecentReceiptsWidget(
            receipts: _getSampleReceipts(),
            onReceiptTap: (receipt) {
              print('تم الضغط على الوصل: ${receipt.code}');
              // يمكن إضافة التنقل إلى صفحة تفاصيل الوصل هنا
            },
            onViewMore: () {
              print('تم الضغط على عرض المزيد');
            },
          ),
        ],
      ),
    );
  }

  Widget buildTitle(
      {String? title, bool more = false, GestureTapCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (more)
            GestureDetector(
              onTap: onTap,
              child: Text(
                "المزيد",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<ReceiptUpdateModel> _getSampleReceipts() {
    return [
      ReceiptUpdateModel(
        id: '1',
        code: '#002940',
        status: 'في المخزن',
        location: 'بغداد - الكرادة',
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ReceiptUpdateModel(
        id: '2',
        code: '#002941',
        status: 'قيد الاستحصال',
        location: 'بغداد - الجادرية',
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ReceiptUpdateModel(
        id: '3',
        code: '#002942',
        status: 'تم التسليم',
        location: 'بغداد - الكاظمية',
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ReceiptUpdateModel(
        id: '4',
        code: '#002943',
        status: 'قيد التوصيل',
        location: 'بغداد - الأعظمية',
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ReceiptUpdateModel(
        id: '5',
        code: '#002944',
        status: 'مؤجل',
        location: 'بغداد - المنصور',
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReceiptUpdateModel(
        id: '6',
        code: '#002945',
        status: 'في الطريق',
        location: 'بغداد - الدورة',
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ReceiptUpdateModel(
        id: '7',
        code: '#002946',
        status: 'تم الاستلام',
        location: 'بغداد - الشعلة',
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }
}
