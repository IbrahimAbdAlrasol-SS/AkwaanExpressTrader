import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'trader_info_tab_widget.dart';
import 'delivery_info_tab_widget.dart';

class RegisterTabsWidget extends StatefulWidget {
  const RegisterTabsWidget({super.key});

  @override
  State<RegisterTabsWidget> createState() => _RegisterTabsWidgetState();
}

class _RegisterTabsWidgetState extends State<RegisterTabsWidget> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // شريط التابات
        _buildTabBar(),

        const Gap(AppSpaces.large),

        // محتوى التاب المحدد
        _buildTabContent(),
      ],
    );
  }

  /// بناء شريط التابات
  Widget _buildTabBar() {
    return Row(
      children: [
        // تاب معلومات التاجر
        Expanded(
          child: _buildTab(
            index: 0,
            title: 'معلومات التاجر',
            isActive: _currentTabIndex == 0,
            color: _getTabColor(0),
          ),
        ),

        const Gap(AppSpaces.medium),

        // تاب معلومات الاستلام
        Expanded(
          child: _buildTab(
            index: 1,
            title: 'معلومات الاستلام',
            isActive: _currentTabIndex == 1,
            color: _getTabColor(1),
          ),
        ),
      ],
    );
  }

  /// بناء تاب واحد
  Widget _buildTab({
    required int index,
    required String title,
    required bool isActive,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Column(
        children: [
          // شريط التاب
          Container(
            width: 187,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpaces.large),
            ),
          ),

          const Gap(AppSpaces.small),

          // اسم التاب
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isActive ? color : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// الحصول على لون التاب حسب الحالة
  Color _getTabColor(int tabIndex) {
    if (_currentTabIndex == 0) {
      // التاب الأول نشط
      if (tabIndex == 0) {
        return const Color(0xFF1A66FF); // أزرق للتاب النشط
      } else {
        return const Color(0xFFF0F0F0); // رمادي للتاب غير النشط
      }
    } else {
      // التاب الثاني نشط
      if (tabIndex == 0) {
        return const Color(0xFF24A870); // أخضر للتاب الأول عند انتقال للثاني
      } else {
        return const Color(0xFF1A66FF); // أزرق للتاب النشط
      }
    }
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return const TraderInfoTabWidget();
      case 1:
        return DeliveryInfoTabWidget(
          onPrevious: _goToPreviousTab,
          onSubmit: _handleSubmit,
        );
      default:
        return const TraderInfoTabWidget();
    }
  }

  void _goToPreviousTab() {
    if (_currentTabIndex > 0) {
      setState(() {
        _currentTabIndex--;
      });
    }
  }

  void _handleSubmit() {
    // TODO: تنفيذ منطق الإرسال
    print('تم إرسال النموذج');
  }
}
