import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ComprehensiveStatisticsWidget extends ConsumerWidget {
  const ComprehensiveStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإحصائيات الشاملة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const Gap(16),
          Row(
            children: [
              // العمود الأول
              Expanded(
                child: Column(
                  children: [
                    _buildStatCard(
                      context,
                      'إجمالي الأرباح',
                      '\$12,450',
                      Icons.trending_up,
                      Colors.green,
                    ),
                    const Gap(12),
                    _buildStatCard(
                      context,
                      'عدد الصفقات',
                      '156',
                      Icons.swap_horiz,
                      Colors.blue,
                    ),
                  ],
                ),
              ),
              // الفاصل العمودي
              Container(
                width: 2,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              // العمود الثاني
              Expanded(
                child: Column(
                  children: [
                    _buildStatCard(
                      context,
                      'إجمالي الخسائر',
                      '\$3,200',
                      Icons.trending_down,
                      Colors.red,
                    ),
                    const Gap(12),
                    _buildStatCard(
                      context,
                      'معدل النجاح',
                      '78%',
                      Icons.check_circle,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const Gap(8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const Gap(4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
