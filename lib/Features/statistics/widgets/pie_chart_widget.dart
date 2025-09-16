import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
 
class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final chartData = [
      {"label": "مكتمل", "value": 444, "color": const Color(0xFF8CD98C)},
      {"label": "قيد التوصيل", "value": 4444, "color": const Color(0xFF80D4FF)},
      {"label": "قيد التحضير", "value": 4444, "color": const Color(0xFFFFE500)},
      {"label": "ملغي", "value": 444, "color": const Color(0xFFE96363)},
      {"label": "مرتجع", "value": 4444, "color": const Color(0xFFAA80FF)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: Center(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 55,
                  sections: chartData.map((data) {
                    double total = chartData.fold(
                        0, (sum, item) => sum + (item['value'] as int));
                    double percent = (data['value'] as int) / total * 100;
                    return _buildPieSection(
                      context,
                      percent,
                      data['color'] as Color,
                      "${percent.toStringAsFixed(0)}%",
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...chartData.map((data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: data['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(data['label'].toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colorScheme.onSurface,
                          )),
                    ],
                  ),
                  Text(data['value'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colorScheme.onSurface,
                      )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  PieChartSectionData _buildPieSection(
      BuildContext context, double value, Color color, String percentText) {
    return PieChartSectionData(
      value: value,
      color: color,
      showTitle: false,
      badgeWidget: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: context.colorScheme.outline, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          percentText,
          style: context.textTheme.titleMedium!.copyWith(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      badgePositionPercentageOffset: 1,
    );
  }
}
