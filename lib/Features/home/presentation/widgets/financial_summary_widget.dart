import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class FinancialSummaryWidget extends StatelessWidget {
  final String receivablesAmount;
  final String debtsAmount;

  const FinancialSummaryWidget({
    super.key,
    required this.receivablesAmount,
    required this.debtsAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // المستحقات
          Expanded(
            child: _buildFinancialItem(
              context,
              'المستحقات',
              receivablesAmount,
              'assets/svg/dollar.svg',
              Colors.green,
            ),
          ),
          // فاصل عمودي
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          // الديون
          Expanded(
            child: _buildFinancialItem(
              context,
              'الديون',
              debtsAmount,
              'assets/svg/wallet.svg',
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialItem(
    BuildContext context,
    String label,
    String amount,
    String iconPath,
    Color color,
  ) {
    return Column(
      children: [
        // الأيقونة
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const Gap(8),
        // المبلغ
        Text(
          amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const Gap(4),
        // التسمية
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}