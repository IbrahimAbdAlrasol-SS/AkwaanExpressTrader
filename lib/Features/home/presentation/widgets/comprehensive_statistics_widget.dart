 import 'statistic_cell_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ComprehensiveStatisticsWidget extends StatelessWidget {
  const ComprehensiveStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // العنوان
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 18.0),
          child: Text(
            'إحصائيــــات شاملة',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        // Container الرئيسي
        const Gap(10),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(
            width: 398,
            height: 207,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16), // Border Radius/large
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  // العمود الأول
                  Expanded(
                    child: Column(
                      children: [
                        // في المخزن
                        Container(
                          height: 67.67,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: const StatisticCellWidget(
                            label: 'في المخزن',
                            value: '25',
                            iconPath: 'assets/svg/Warehouse.svg',
                            iconColor: Colors.blue,
                          ),
                        ),
                        // تم التسليم
                        Container(
                          height: 67.67,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: const StatisticCellWidget(
                            label: 'تم التسليم',
                            value: '30',
                            iconPath: 'assets/svg/Checks.svg',
                            iconColor: Colors.green,
                          ),
                        ),
                        // الطلبات الراجعة
                        Container(
                          height: 67.67,
                          child: const StatisticCellWidget(
                            label: 'الطلبات الراجعة',
                            value: '5',
                            iconPath: 'assets/svg/x.svg',
                            iconColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // فاصل عمودي
                  Container(
                    width: 2,
                    height: 203,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  // العمود الثاني
                  Expanded(
                    child: Column(
                      children: [
                        // قيد الاستحصال
                        Container(
                          height: 67.67,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: StatisticCellWidget(
                            label: 'قيد الاستحصال',
                            value: '10',
                            iconPath: 'assets/svg/box.svg',
                            iconColor: Colors.orange,
                          ),
                        ),
                        // قيد التوصيل
                        Container(
                          height: 67.67,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: const StatisticCellWidget(
                            label: 'قيد التوصيل',
                            value: '12',
                            iconPath: 'assets/svg/Truck.svg',
                            iconColor: Colors.teal,
                          ),
                        ),
                        // الطلبات المؤجلة
                        Container(
                          height: 67.67,
                          child: const StatisticCellWidget(
                            label: 'الطلبات المؤجلة',
                            value: '1',
                            iconPath: 'assets/svg/SpinnerGap.svg',
                            iconColor: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
