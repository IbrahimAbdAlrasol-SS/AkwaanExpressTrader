import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsHeader extends StatefulWidget {
  final VoidCallback onDownloadTap;

  const StatisticsHeader({
    super.key,
    required this.onDownloadTap,
  });

  @override
  State<StatisticsHeader> createState() => _StatisticsHeaderState();
}

class _StatisticsHeaderState extends State<StatisticsHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onDownloadTap,
            borderRadius: BorderRadius.circular(66),
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(66),
                border: Border.all(color: context.colorScheme.primary),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/svg/FileArrowDown.svg",
                    color: context.colorScheme.primary,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تحميل تقرير',
                    style: context.textTheme.labelLarge!.copyWith(
                      color: context.colorScheme.primary,
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
    );
  }
}
