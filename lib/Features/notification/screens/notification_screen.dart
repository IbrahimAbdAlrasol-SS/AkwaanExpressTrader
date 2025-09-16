import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/utils/helpers/timeAgoArabic.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(
              title: "الإشعارات",
              showBackButton: true,
            ),
            Expanded(
              child: ListView.separated(
                // BouncingScrollPhysics for better touch smoothness
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0), // تحسين padding
                itemCount: 3,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(
                    thickness: 0.1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                itemBuilder: (context, index) =>
                    notificationItemWidget(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget notificationItemWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 8.0, vertical: 12.0), // إضافة padding
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              border: Border.all(color: Theme.of(context).colorScheme.primary)),
          child: Icon(
            CupertinoIcons.bell,
            color: Theme.of(context).colorScheme.primary,
            size: 18.sp,
          ),
        ),
        const Gap(16), // تحسين المسافة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "تم تأكيد طلبك بنجاح",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    timeAgoArabic(DateTime.now()),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: context.colorScheme.secondary),
                  ),
                ],
              ),
              const SizedBox(height: 8), // تحسين المسافة
              Text(
                "تم تأكيد طلبك بنجاح ونعمل على تجهيزه وتوصيله في أقرب وقت",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
