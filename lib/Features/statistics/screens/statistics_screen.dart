import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/Others/build_cart.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20), // زيادة padding للشاشة
          child: SingleChildScrollView(
            // ************************************************ ممكن يسبب مشكلة بسلاسة اللمس ********************
            physics: const BouncingScrollPhysics(), // تحسين سلاسة التمرير
            // ************************************************
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "إحصائيات شاملة",
                          style: context.textTheme.titleMedium!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "لتفاصيل اكثر اضغط على تحميل تقرير",
                          style: context.textTheme.bodySmall!.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _showReportBottomSheet(context),
                        borderRadius: BorderRadius.circular(66),
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8FCF5),
                            borderRadius: BorderRadius.circular(66),
                            border: Border.all(color: const Color(0xFF16CA8B)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/FileArrowDown.svg",
                                color: const Color(0xFF0C6E4C),
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'تحميل تقرير',
                                style: context.textTheme.labelLarge!.copyWith(
                                  color: const Color(0xFF0C6E4C),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(16), // زيادة المسافة
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0), // إضافة padding جانبي
                  child: Text(
                    "أرباح اليوم",
                    style: context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Gap(8), // زيادة المسافة

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0), // إضافة padding للكارت
                  child: buildCart(
                    context,
                    title: "إجمالي الأرباح",
                    subtitle: '300,000',
                    iconPath: "assets/svg/coines.svg",
                    iconColor: const Color(0xFF16CA8B),
                    expanded: false,
                  ),
                ),
                Gap(20), // زيادة المسافة
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0), // إضافة padding
                  child: Text(
                    "إحصائيات حالة الطلبات اليومية",
                    style: context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Gap(12), // زيادة المسافة
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0), // إضافة padding للرسم البياني
                  child: _buildPieChart(context),
                ),
                Gap(12),
                Text(
                  "إحصائيات الإيرادات الشهرية",
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                _buildLineChart(context),
                const SizedBox(height: 24),

                // 👇 Add Province Chart
                Text(
                  "عدد الطلبات حسب المحافظة",
                  style: context.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                _buildProvinceOrdersChart(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProvinceOrdersChart() {
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
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
                onTap: () async {
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
                        selectedMonthBackgroundColor:
                            Theme.of(context).primaryColor,
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
                },
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

  Widget _buildLineChart(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الأرباح الكلية",
                    style: context.textTheme.titleMedium!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "10,000,000 د.ع",
                    style: context.textTheme.headlineSmall!.copyWith(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
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
                        selectedMonthBackgroundColor:
                            Theme.of(context).primaryColor,
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
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 22,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${selectedDate.month}/${selectedDate.year}",
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['01', '02', '03', '04', '05', '06'];
                        return Text(
                          months[value.toInt() % months.length],
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: false,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 5),
                      FlSpot(1, 9),
                      FlSpot(2, 6),
                      FlSpot(3, 10),
                      FlSpot(4, 7),
                      FlSpot(5, 8),
                    ],
                    isCurved: true,
                    color: const Color(0xff314CFF),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xff314CFF).withOpacity(0.6),
                          const Color(0xff314CFF).withOpacity(0.3),
                          const Color(0xff314CFF).withOpacity(0.1),
                          const Color(0xff314CFF).withOpacity(0.05),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
                      ),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final chartData = [
      {"label": "مكتمل", "value": 444, "color": const Color(0xFF8CD98C)},
      {"label": "قيد التوصيل", "value": 4444, "color": const Color(0xFF80D4FF)},
      {"label": "قيد التحضير", "value": 4444, "color": const Color(0xFFFFE500)},
      {"label": "ملغي", "value": 444, "color": const Color(0xFFE96363)},
      {"label": "مرتجع", "value": 4444, "color": const Color(0xFFAA80FF)},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  Text(data['value'].toString(),
                      style: const TextStyle(fontSize: 14)),
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
          color: Colors.white,
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

  void _showReportBottomSheet(BuildContext context) {
    String selectedReportType = 'إحصائيات الطلبات الشاملة';
    String selectedFormat = 'Pdf';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(24),

              // Report Type Section
              Text(
                'نوع التقرير',
                style: context.textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Gap(12),
              CustomTextFormField<String>(
                label: '',
                hint: selectedReportType,
                showLabel: false,
                readOnly: true,
                prefixInner: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    "assets/svg/ArrowsDownUp.svg",
                    color: Theme.of(context).colorScheme.primary,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const Gap(24),

              // Report Format Section
              Text(
                'صيغة التقرير',
                style: context.textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Gap(16),

              // Format Options - Two Containers with Vertical Divider
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // CSV Container
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedFormat = 'Csv'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            color: selectedFormat == 'Csv'
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedFormat == 'Csv'
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selectedFormat == 'Csv'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: selectedFormat == 'Csv'
                                    ? Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      )
                                    : null,
                              ),
                              const Gap(8),
                              Text(
                                'CSV',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: selectedFormat == 'Csv'
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Vertical Divider
                    Container(
                      width: 0.5,
                      height: 40,
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.3),
                    ),

                    // PDF Container
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedFormat = 'Pdf'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            color: selectedFormat == 'Pdf'
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selectedFormat == 'Pdf'
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selectedFormat == 'Pdf'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: selectedFormat == 'Pdf'
                                    ? Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      )
                                    : null,
                              ),
                              const Gap(8),
                              Text(
                                'PDF',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: selectedFormat == 'Pdf'
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(80),

              // Download Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FillButton(
                    label: 'تحميل التقرير',
                    width: 398,
                    height: 50,
                    borderRadius: 30, // Very smooth border radius
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        "assets/svg/FileArrowDown.svg",
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 20,
                        height: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Add download logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'تم بدء تحميل التقرير بصيغة $selectedFormat'),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
