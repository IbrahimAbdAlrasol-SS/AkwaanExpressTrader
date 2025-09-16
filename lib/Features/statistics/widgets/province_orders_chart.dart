import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ProvinceOrdersChart extends StatefulWidget {
  const ProvinceOrdersChart({super.key});

  @override
  State<ProvinceOrdersChart> createState() => _ProvinceOrdersChartState();
}

class _ProvinceOrdersChartState extends State<ProvinceOrdersChart> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final List<String> provinces = [
      'ذي قار',
      'واسط',
      'بابل',
      'موصل',
      'بصرة',
      'اربيل',
      'بغداد'
    ];
    final List<int> values = [182, 90, 1203, 390, 194, 267, 6777];
    final double maxY = values.reduce((a, b) => a > b ? a : b).toDouble() * 1.2;
    final int totalOrders = values.reduce((a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Widget and Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title and Total Orders
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الطلبات الكلية',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        totalOrders.toString(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        " طلب",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Date Widget
              GestureDetector(
                onTap: () => _showMonthPicker(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${selectedDate.year}/${selectedDate.month.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Chart
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final int index = value.toInt();
                        if (index >= 0 && index < provinces.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              provinces[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      reservedSize: 42,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barGroups: List.generate(provinces.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: values[index].toDouble(),
                        width: 40,
                        color: const Color(0xFF00C389),
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxY,
                          color: const Color(0xFFF3F5F7),
                        ),
                        rodStackItems: [
                          BarChartRodStackItem(
                            0,
                            values[index].toDouble(),
                            const Color(0xFF00C389),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: PickerDialogSettings(
          locale: const Locale('ar'),
          dialogRoundedCornersRadius: 20,
        ),
        headerSettings: PickerHeaderSettings(
          headerBackgroundColor: Theme.of(context).primaryColor,
          headerCurrentPageTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        dateButtonsSettings: PickerDateButtonsSettings(
          selectedMonthBackgroundColor: Theme.of(context).primaryColor,
          selectedMonthTextColor: Colors.white,
          unselectedMonthsTextColor: Colors.grey[600]!,
          currentMonthTextColor: Theme.of(context).primaryColor,
        ),
        actionBarSettings: PickerActionBarSettings(
          confirmWidget: Text(
            'تأكيد',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          cancelWidget: Text(
            'إلغاء',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
