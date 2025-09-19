import 'package:Tosell/Features/home/data/models/Home.dart';
import 'package:Tosell/Features/home/presentation/providers/home_provider.dart';
import 'package:Tosell/Features/profile/providers/profile_provider.dart';
import 'package:Tosell/Features/profile/screens/myProfile_Screen.dart';
import 'package:Tosell/Features/receipt/widgets/recent_receipts_widget.dart';
import 'package:Tosell/Features/notification/widgets/recent_notifications_widget.dart';
import 'package:Tosell/Features/notification/models/notification_model.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: homeState.when(
        data: (data) =>
            _buildUi(context, user: userState.value ?? User(), home: data),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildUi(BuildContext context,
      {required User user, required Home home}) {
    return CustomScrollView(
      slivers: [
        // SliverAppBar مع HomeHeaderWidget ثابت في الأعلى

        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          elevation: 0,
          backgroundColor: const Color(0xFF134AB9),
          title: HomeHeaderWidget(
            user: user,
            home: home,
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF134AB9),
                    Color(0xFF1A66FF),
                  ],
                ),
              ),
              child: const SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const Gap(100), // مساحة للـ HomeHeaderWidget الثابت
                      const FinancialSummaryWidget(
                        receivablesAmount: '90,000',
                        debtsAmount: '50,000',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // ActionCounterWidget في المنطقة الانتقالية
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A66FF), // لون أزرق عميق وقوي
                  Colors.white, // انتقال للأبيض
                ],
                stops: [
                  0.15,
                  0.15
                ], // تقليل منطقة الانتقال لجعل الأزرق أكثر وضوحاً
              ),
            ),
            child: ActionCounterWidget(
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
          ),
        ),

        // باقي محتوى الصفحة القابل للتمرير
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const Gap(20),
                const ComprehensiveStatisticsWidget(),
                const Gap(20),
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
                const Gap(20),
                RecentNotificationsWidget(
                  notifications: _getSampleNotifications(),
                  onNotificationTap: (notification) {
                    print('تم الضغط على الإشعار: ${notification.title}');
                    // يمكن إضافة التنقل إلى صفحة تفاصيل الإشعار هنا
                  },
                  onViewMore: () {
                    print('تم الضغط على عرض المزيد من الإشعارات');
                  },
                ),
                const Gap(40),
              ],
            ),
          ),
        ),
      ],
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
        deliveryTime: DateTime.now().subtract(const Duration(minutes: 30)),
        id: '1',
        code: '#002940',
        status: 'في المخزن',
        location: 'بغداد - الكرادة',
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        amount: 10000, // مبلغ الاستحقاق
      ),
      ReceiptUpdateModel(
        deliveryTime: DateTime.now().subtract(const Duration(hours: 2)),
       //  formattedDateTime: '2023-08-25 10:30:00', // الوقت بصيغة منسقة
        id: '2',
        code: '#002941',
        status: 'قيد الاستحصال',
        location: 'بغداد - الجادرية',
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        amount: 15000, // مبلغ الاستحقاق
      ),
    ];
  }

  List<NotificationModel> _getSampleNotifications() {
    return [
      NotificationModel(
        id: '1',
        type: NotificationType.order,
        title: 'طلب جديد',
        description: 'تم استلام طلب جديد برقم #002950 من العميل أحمد محمد',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.delivery,
        title: 'تم التسليم',
        description:
            'تم تسليم الطلب #002948 بنجاح إلى العميل في بغداد - الكرادة',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
    ];
  }
}
