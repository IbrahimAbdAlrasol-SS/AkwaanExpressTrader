import 'dart:collection';

import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/utils/extensions/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/Others/custom_phoneNumbrt.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/widgets/buttons/OutlineButton.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/layouts/custom_section.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChangeStateScreen extends ConsumerStatefulWidget {
  final String code;
  const ChangeStateScreen({super.key, required this.code});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeStateScreenState();
}

class _ChangeStateScreenState extends ConsumerState<ChangeStateScreen> {
  bool isButtonLoading = false;
  HashSet<String> selectedIds = HashSet();
  int handelProductState(int state) {
    return state;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Widget buildUi(BuildContext context, order) {
    if (order == null) {
      return const Center(child: Text('لايوجد طلب بهذا الكود '));
    }
    if (order.status! >= 9) {
      return const Center(child: Text('الطلب مكتمل لايمكنك تعديل الحالة'));
    }
    var date = DateTime.parse(order.creationDate!);

    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomAppBar(
          title: "تفاصيل الطلب",
          showBackButton: false,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomSection(
                  title: "معلومات الطلب",
                  icon: SvgPicture.asset(
                    "assets/svg/Receipt.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  childrenRadius: const BorderRadius.all(Radius.circular(16)),
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("رقم الطلب", "assets/svg/User.svg",
                              Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(order.code ?? 'لايوجد')),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("التاريخ",
                              "assets/svg/CalendarBlank.svg", Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(
                                  "${date.day}.${date.month}.${date.year}")),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "السعر",
                            "assets/svg/MapPinArea.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget:
                                Text(order.amount?.toString() ?? "لايوجد"),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                  ],
                ),
                CustomSection(
                  title: "معلومات الزبون",
                  icon: SvgPicture.asset(
                    "assets/svg/User.svg",
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  childrenRadius: const BorderRadius.all(Radius.circular(16)),
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("أسم الزبون",
                              "assets/svg/UserCircle.svg", Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget: Text(order.customerName ?? "لايوجد")),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "رقم الهاتف",
                            "assets/svg/Phone.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget: Text(
                              customPhoneNumber(
                                  order.customerPhoneNumber ?? "لايوجد"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOrderSection("المحافظة",
                              "assets/svg/MapPinLine.svg", Theme.of(context),
                              padding: const EdgeInsets.only(bottom: 3, top: 3),
                              subWidget:
                                  Text(order.deliveryZone?.name ?? "لايوجد")),
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const Gap(AppSpaces.small),
                          buildOrderSection(
                            "المنطقة",
                            "assets/svg/MapPinArea.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget:
                                Text(order.deliveryZone?.name ?? "لايوجد"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics:
                //       const NeverScrollableScrollPhysics(), // Prevents conflict with the parent scroll
                //   itemCount: order.products?.length ?? 0,
                // itemBuilder: (context, index) =>
                buildProductInfo(
                  isSelect: false,
                  context,
                  content: order.content ?? "لايوجد",
                  selectAble: order.status == 5,
                ),

                const Gap(AppSpaces.medium),
                Container(
                  padding: AppSpaces.allMedium,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedCustomButton(
                          borderColor: Theme.of(context).colorScheme.outline,
                          label: "غلق",
                          textColor: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            context.go(AppRoutes.home);
                          },
                        ),
                      ),
                      const Gap(AppSpaces.medium),
                      Expanded(
                        child: FillButton(
                          color: Theme.of(context).colorScheme.primary,
                          label: "تاكيد التغيير",
                          isLoading: isButtonLoading,
                          onPressed: () async {
                            String? error;
                            changeLoadingState(true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Center _buildCodeNotFound(Object error) {
    return Center(
        child: Column(
      children: [
        const CustomTextFormField(
          label: "كود الطلب",
          hint: 'ادخل رقم الطلب يدويا رجاء',
        ),
        SvgPicture.asset(
          "assets/svg/notFound.svg",
          width: 200,
          height: 200,
        ),
      ],
    ));
  }

  void changeLoadingState(bool state) {
    setState(() {
      isButtonLoading = state;
    });
  }

  Widget buildProductInfo(BuildContext context,
      {required String content,
      required bool isSelect,
      required bool selectAble}) {
    return GestureDetector(
      onTap: () {
        if (selectAble) {
          setState(() {
            // if(selectedIds.contains(product.id))
            // {
            // selectedIds.remove(product.id!);

            // }else
            // selectedIds.add(product.id!);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelect
              ? context.colorScheme.primary
              : Colors.transparent, // Change color if selected
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          // border: Border.all(
          //   color: true
          //       ? Colors.blue
          //       : Colors.transparent, // Highlight border when selected
          // ),
        ),
        child: CustomSection(
          title: "معلومات المنتج",
          icon: SvgPicture.asset(
            "assets/svg/box.svg",
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          childrenRadius: const BorderRadius.all(Radius.circular(16)),
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildOrderSection(
                      "الاسم", "assets/svg/Cards.svg", Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content ?? "لايوجد")),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Gap(AppSpaces.small),
                  buildOrderSection(
                      "العدد", "assets/svg/BoundingBox.svg", Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content ?? "لايوجد")),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildOrderSection(
                      "التكلفة", "assets/svg/Cards.svg", Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content ?? "لايوجد")),
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const Gap(AppSpaces.small),
                  buildOrderSection("حالة المنتج", "assets/svg/BoundingBox.svg",
                      Theme.of(context),
                      padding: const EdgeInsets.only(bottom: 3, top: 3),
                      subWidget: Text(content)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderSection(
    String title,
    String iconPath,
    ThemeData theme, {
    void Function()? onTap,
    EdgeInsets? padding,
    Widget? subWidget,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary,
                        fontFamily: "Tajawal",
                      ),
                    ),
                    if (subWidget != null) subWidget
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
