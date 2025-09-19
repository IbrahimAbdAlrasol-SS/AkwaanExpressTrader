import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceiptTabsWidget extends StatelessWidget {
  final TabController tabController;

  const ReceiptTabsWidget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 398,
      height: 54,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(16), // Border Radius/large
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Border Radius/medium
          border: Border.all(
            color: const Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.black,
        unselectedLabelColor:
            Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Tajawal',
        ),
        labelPadding: const EdgeInsets.only(top: 6),
        tabs: const [
          Tab(text: 'النشطة'),
          Tab(text: 'المكتملة'),
          Tab(text: 'الراجعة'),
        ],
      ),
    );
  }
}
