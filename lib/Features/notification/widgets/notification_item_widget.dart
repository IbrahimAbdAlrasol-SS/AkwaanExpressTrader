import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  const NotificationItemWidget({
    super.key,
    required this.notification,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (isFirst && isLast) {
      // عنصر واحد فقط
      borderRadius = BorderRadius.circular(12);
    } else if (isFirst) {
      // العنصر الأول
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
    } else if (isLast) {
      // العنصر الأخير
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    } else {
      // العناصر الوسطى
      borderRadius = BorderRadius.circular(0);
    }

    return Container(
        width: 398,
        height: 100,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 0.8,
          ),
        ),
      child: Material(
        color: Colors.transparent,
        borderRadius: _getBorderRadius(),
        child: InkWell(
          onTap: onTap,
          borderRadius: _getBorderRadius(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 12,
              bottom: 12,
            ),
            child: Row(
              children: [
                // الأيقونة
                _buildIconContainer(),
               const Gap(8),
                // المحتوى
                Expanded(
                  child: _buildContent(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Border Radius/large
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          notification.icon,
          size: 24,
          color: notification.iconColor,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // التاريخ والوقت
          _buildDateTime(),
          const Gap(4),
          // العنوان
          _buildTitle(context),
          const Gap(2),
          // الوصف
          _buildDescription(context),
        ],
      ),
    );
  }

  Widget _buildDateTime() {
    final dateFormat = DateFormat('yyyy/MM/dd – hh:mm a', 'ar');
    final formattedDate = dateFormat.format(notification.createdAt);

    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        formattedDate,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 14,
          height: 1.0,
          letterSpacing: 0,
          color: Color(0xFF8C8C8C),
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        notification.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.0,
          letterSpacing: 0,
          color: Color(0xFF1E1E1E),
        ),
        textAlign: TextAlign.right,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Flexible(
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          notification.description.isNotEmpty 
              ? notification.description 
              : 'لا يوجد وصف',
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            height: 1.2, // تحديد ارتفاع السطر بوضوح
            letterSpacing: 0,
            color: Color(0xFF666666),
          ),
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true, // السماح بالتفاف النص
        ),
      ),
    );
  }

  // تحديد نصف قطر الحواف حسب موقع العنصر
  BorderRadius _getBorderRadius() {
    if (isFirst && isLast) {
      // عنصر واحد فقط - جميع الأركان منحنية
      return BorderRadius.circular(16);

    } else if (isFirst) {
      // العنصر الأول - الأركان العلوية منحنية فقط
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      );
    } else if (isLast) {
      // العنصر الأخير - الأركان السفلية منحنية فقط
      return const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      );
    } else {
      // العناصر الوسطية - بدون انحناء
      return BorderRadius.zero;
    }
  }

  // تحديد الحدود حسب موقع العنصر
  Border? _getBorder() {
    if (isLast) {
      // العنصر الأخير - بدون حد سفلي
      return null;
    } else {
      // باقي العناصر - حد سفلي فقط
      return Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      );
    }
  }
}
