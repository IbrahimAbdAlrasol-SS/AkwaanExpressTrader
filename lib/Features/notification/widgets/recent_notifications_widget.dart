import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import 'notification_item_widget.dart';

class RecentNotificationsWidget extends StatelessWidget {
  final List<NotificationModel> notifications;
  final int maxDisplayCount;
  final VoidCallback? onViewMore;
  final Function(NotificationModel)? onNotificationTap;

  const RecentNotificationsWidget({
    super.key,
    required this.notifications,
    this.maxDisplayCount = 3,
    this.onViewMore,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    // ترتيب الإشعارات حسب آخر تحديث
    final sortedNotifications = List<NotificationModel>.from(notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'آخر الإشعارات',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 15,
                ),
          ),
        ),
        // العرض الديناميكي حسب عدد العناصر
        _buildDynamicDisplay(sortedNotifications, context),
      ],
    );
  }

  Widget _buildDynamicDisplay(
      List<NotificationModel> sortedNotifications, BuildContext context) {
    final notificationCount = sortedNotifications.length;

    // إذا القائمة فارغة → يظهر "لا يوجد إشعارات"
    if (notificationCount == 0) {
      return _buildEmptyState(context);
    }

    // إذا فيها عنصر واحد → يعرض صف واحد
    else if (notificationCount == 1) {
      return _buildSingleNotification(sortedNotifications.first, context);
    }

    // إذا فيها عنصران → صفين مدمجين
    else if (notificationCount == 2) {
      return _buildTwoNotifications(
          sortedNotifications.take(2).toList(), context);
    }

    // إذا فيها ثلاثة أو أكثر → يعرض أول 3 فقط مدمجين
    else {
      final displayNotifications =
          sortedNotifications.take(maxDisplayCount).toList();
      final remainingCount = notificationCount - maxDisplayCount;
      return _buildMultipleNotifications(
          displayNotifications, remainingCount, context);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'لا يوجد إشعارات',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  // عرض عنصر واحد فقط
  Widget _buildSingleNotification(
      NotificationModel notification, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: NotificationItemWidget(
        notification: notification,
        onTap: () => onNotificationTap?.call(notification),
        isFirst: true,
        isLast: true,
      ),
    );
  }

  // عرض عنصرين مدمجين
  Widget _buildTwoNotifications(
      List<NotificationModel> notifications, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: notifications.asMap().entries.map((entry) {
          final index = entry.key;
          final notification = entry.value;
          return NotificationItemWidget(
            notification: notification,
            onTap: () => onNotificationTap?.call(notification),
            isFirst: index == 0,
            isLast: index == notifications.length - 1,
          );
        }).toList(),
      ),
    );
  }

  // عرض متعدد مع إمكانية إضافة زر "عرض المزيد" لاحقاً
  Widget _buildMultipleNotifications(
    List<NotificationModel> displayNotifications,
    int remainingCount,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // عرض الإشعارات المحددة (أول 3 مدمجين)
          ...displayNotifications.asMap().entries.map((entry) {
            final index = entry.key;
            final notification = entry.value;
            return NotificationItemWidget(
              notification: notification,
              onTap: () => onNotificationTap?.call(notification),
              isFirst: index == 0,
              isLast: index == displayNotifications.length - 1,
            );
          }).toList(),
        ],
      ),
    );
  }
}
