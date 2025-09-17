
import 'package:Tosell/features/home/presentation/widgets/brand_image_widget.dart';
import 'package:Tosell/features/home/presentation/widgets/welcome_text_widget.dart';
import 'package:Tosell/features/home/presentation/widgets/notification_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:Tosell/core/model_core/User.dart';
import 'package:gap/gap.dart';

import '../../data/models/Home.dart';


/// Widget رئيسي لـ header الصفحة الرئيسية
class HomeHeaderWidget extends StatelessWidget {
  final User user;
  final Home home;

  const HomeHeaderWidget({
    super.key,
    required this.user,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // صورة المتجر/المستخدم
          BrandImageWidget(
            imageUrl:   user.img,
            size: 50,
          ),

          const Gap(12), // مسافة بين الصورة والنص

          // نص الترحيب واسم المتجر/المستخدم
          Expanded(
            child: WelcomeTextWidget(
              user: user,
            ),
          ),

          const Gap(12), // مسافة بين النص وزر الإشعارات

          // زر الإشعارات
          NotificationButtonWidget(
            notificationCount: 3,
            onTap: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
    );
  }
}
