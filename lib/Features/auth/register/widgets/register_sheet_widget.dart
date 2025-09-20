import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'register_tabs_widget.dart';

/// ✅ Widget للورقة القابلة للطي في شاشة التسجيل - بدون form
class RegisterSheetWidget extends StatelessWidget {
  const RegisterSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;

    // حساب الحجم المناسب بناءً على حالة لوحة المفاتيح
    double calculateChildSize() {
      if (keyboardHeight > 0) {
        // عندما تكون لوحة المفاتيح مفتوحة، نقلل الحجم
        return 0.5;
      } else {
        // عندما تكون لوحة المفاتيح مغلقة
        return 0.72;
      }
    }

    final childSize = calculateChildSize();

    return DraggableScrollableSheet(
      initialChildSize: childSize,
      minChildSize: keyboardHeight > 0 ? 0.3 : 0.72,
      maxChildSize: keyboardHeight > 0 ? 0.8 : 0.84,
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppSpaces.exLarge),
                topLeft: Radius.circular(AppSpaces.exLarge),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppSpaces.exLarge),
                topLeft: Radius.circular(AppSpaces.exLarge),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.5,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpaces.medium,
                      right: AppSpaces.medium,
                      bottom: keyboardHeight > 0
                          ? 20
                          : MediaQuery.of(context).padding.bottom + 20,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Gap(AppSpaces.medium),

                        // ✅ مساحة فارغة - النصوص الآن في الهيدر
                        const SizedBox.shrink(),

                        const Gap(AppSpaces.large),

                        // ✅ نظام التابات
                        const RegisterTabsWidget(),

                        //const Gap(AppSpaces.exLarge),

                        // ✅ مساحة إضافية لضمان التغطية الكاملة
                        //  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
