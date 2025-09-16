import 'package:Tosell/core/utils/extensions/extensions.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
class ReportBottomSheet extends StatefulWidget {
  const ReportBottomSheet({super.key});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  String selectedReportType = 'إحصائيات الطلبات الشاملة';
  String selectedFormat = 'Pdf';

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Gap(16),

          // Report Type Section
          Text(
            'نوع التقرير',
            style: context.textTheme.titleMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Gap(8),
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
          const Gap(16),

          // Report Format Section
          Text(
            'صيغة التقرير',
            style: context.textTheme.titleMedium!.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Gap(8),

          // Format Options - Two Containers with Vertical Divider
          _buildFormatSelector(),
          const Gap(12),

          // Download Button
          _buildDownloadButton(),
          const Gap(8),
        ],
      ),
    );
  }

  Widget _buildFormatSelector() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedFormat == 'Csv'
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRadioButton('Csv'),
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
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),

          // PDF Container
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedFormat = 'Pdf'),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedFormat == 'Pdf'
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRadioButton('Pdf'),
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
    );
  }

  Widget _buildRadioButton(String format) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selectedFormat == format
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        border: Border.all(
          color: selectedFormat == format
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: selectedFormat == format
          ? Icon(
              Icons.check,
              size: 12,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم بدء تحميل التقرير بصيغة $selectedFormat'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/FileArrowDown.svg",
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 24,
                  height: 24,
                ),
                const Gap(12),
                Text(
                  'تحميل التقرير',
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => const ReportBottomSheet(),
    );
  }
}
