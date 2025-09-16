import 'package:Tosell/Features/profile/providers/profile_provider.dart';
import 'package:Tosell/Features/profile/screens/myProfile_Screen.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/model_core/User.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/Others/build_cart.dart';
import 'package:Tosell/features/home/data/models/Home.dart';
import 'package:Tosell/features/home/presentation/providers/home_provider.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/notification/screens/notification_screen.dart';

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
        body: homeState.when(
          data: (data) =>
              _buildUi(context, user: userState.value ?? User(), home: data),
          error: (error, _) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Column _buildUi(BuildContext context,
      {required User user, required Home home}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAppBar(
          title: "مرحبًا، ${user.userName}",
          showBackButton: false,
          subtitle: "إليك لمحة عن نشاطك اليوم.",
          buttonWidget: CircleAvatar(
            backgroundImage: NetworkImage(ProfileImage),
            radius: 20,
          ),
          actions: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outline)),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.bell),
                    onPressed: () {
                      context.push("/notifications");
                    },
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.error,
                    ),
                    width: 10,
                    height: 10,
                  ),
                )
              ],
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            // ************************************************ ممكن يسبب مشكلة بسلاسة اللمس ********************
            physics: const BouncingScrollPhysics(), // تحسين سلاسة التحكم
            // ************************************************************************************************
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0, vertical: 4.0), // تحسين padding عام
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(AppSpaces.medium), // زيادة المسافة
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // إضافة padding للعنوان
                  child: buildTitle(title: "إحصائيات عامة"),
                ),
                const Gap(AppSpaces.medium), // زيادة المسافة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCart(
                        context,
                        title: "قيد الإستلام",
                        subtitle: home.inPickUpProgress?.toString() ?? 'لايوجد',
                        iconPath: "assets/svg/SpinnerGap.svg",
                        iconColor: Theme.of(context).colorScheme.primary,
                      ),
                      const Gap(AppSpaces.small),
                      buildCart(
                        context,
                        title: "في المخزن ",
                        subtitle: home.inWarehouse?.toString() ?? 'لايوجد',
                        iconPath: "assets/svg/Warehouse.svg",
                        iconColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpaces.small),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCart(
                        context,
                        title: "قيد التوصيل",
                        subtitle:
                            home.inDeliveryProgress?.toString() ?? 'لايوجد',
                        iconPath: "assets/svg/Truck.svg",
                        iconColor: Theme.of(context).colorScheme.error,
                      ),
                      const Gap(AppSpaces.small),
                      buildCart(
                        context,
                        title: "تم الإستلام",
                        subtitle: home.delivered?.toString() ?? 'لايوجد',
                        iconPath: "assets/svg/Checks.svg",
                        iconColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                const Gap(AppSpaces.large),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // إضافة padding للعنوان
                  child: buildTitle(
                    title: "إحصائيات هذا اليوم",
                    more: true,
                    onTap: () =>
                        GoRouter.of(context).push(AppRoutes.transactions),
                  ),
                ),
                const Gap(AppSpaces.medium), // زيادة المسافة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: buildCart(
                    context,
                    title: "إجمالي الأرباح",
                    subtitle: home.dailyProfits?.toInt().toString() ?? 'لايوجد',
                    iconPath: "assets/svg/coines.svg",
                    iconColor: Theme.of(context).colorScheme.primary,
                    expanded: false,
                  ),
                ),
                const Gap(AppSpaces.exSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: buildCart(
                    context,
                    title: "الطلبات المكتملة",
                    subtitle: home.dailyDoneOrders?.toString() ?? 'لايوجد',
                    iconPath: "assets/svg/CheckSquare.svg",
                    iconColor: Theme.of(context).colorScheme.primary,
                    expanded: false,
                  ),
                ),
                const Gap(AppSpaces.exSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: buildCart(
                    context,
                    title: "الطلبات المرتجعة",
                    subtitle: home.dailyReturnedOrders?.toString() ?? 'لايوجد',
                    iconPath: "assets/svg/BoxArrowDown.svg",
                    iconColor: Theme.of(context).colorScheme.error,
                    expanded: false,
                  ),
                ),
                const Gap(AppSpaces.large),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // إضافة padding للعنوان
                  child: buildTitle(
                    title: "أبرز الطلبات",
                    more: true,
                    onTap: () => GoRouter.of(context).push(AppRoutes.orders),
                  ),
                ),
                const Gap(AppSpaces.small),
                // تحسين سلاسة التحكم - استخدام BouncingScrollPhysics بدلاً من NeverScrollableScrollPhysics
                ListView.builder(
                  itemCount: home.orders?.length ?? 0,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(), // تحسين سلاسة التحكم
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                        bottom: 12.0, left: 16.0, right: 16.0), // تحسين padding
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.orderDetails,
                          extra: home.orders?[index].id),
                      child: buildCart(
                        context,
                        title: home.orders?[index].customerName,
                        subtitle: "error in model",
                        iconPath: "assets/svg/box.svg",
                        iconColor: Theme.of(context).colorScheme.primary,
                        expanded: false,
                        state: "تم الاستلام",
                        isOrder: true,
                      ),
                    ),
                  ),
                ),
                const Gap(AppSpaces.medium), // إضافة مسافة
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0), // إضافة padding للعنوان
                  child: buildTitle(
                    title: "إشعاراتك اليوم",
                    more: true,
                    onTap: () => GoRouter.of(context).push(AppRoutes.orders),
                  ),
                ),
                const Gap(AppSpaces.small),
                // تحسين سلاسة التحكم - استخدام BouncingScrollPhysics بدلاً من NeverScrollableScrollPhysics
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0), // تحسين padding
                  physics: const BouncingScrollPhysics(), // تحسين سلاسة التحكم
                  itemCount: 3,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(
                      thickness: 0.1,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  itemBuilder: (context, index) =>
                      notificationItemWidget(context),
                ),
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
}
