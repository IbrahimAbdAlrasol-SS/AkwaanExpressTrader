import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class AddReceiptColumnWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const AddReceiptColumnWidget({
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
          // أيقونة إضافة وصل
          Center(
            child: SvgPicture.asset(
              'assets/svg/Receipt.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const Gap(8),
          // نص إضافة وصل
          Text(
            'إضافة وصل',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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