import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class InvoiceHistoryColumnWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const InvoiceHistoryColumnWidget({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة سجل الفواتير
          Center(
            child: SvgPicture.asset(
              'assets/svg/invoice.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const Gap(8),
          // نص سجل الفواتير
          Text(
            'سجل الفواتير',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}