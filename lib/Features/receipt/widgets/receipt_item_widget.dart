import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../models/receipt_update_model.dart';

class ReceiptItemWidget extends StatelessWidget {
  final ReceiptUpdateModel receipt;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  const ReceiptItemWidget({
    super.key,
    required this.receipt,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    if (isFirst && isLast) {
      // عنصر واحد فقط
      borderRadius = BorderRadius.circular(12);
    } else if (isFirst) {
      // العنصر الأول
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
    } else if (isLast) {
      // العنصر الأخير
      borderRadius = const BorderRadius.only(
        bottomLeft: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    } else {
      // العناصر الوسطى
      borderRadius = BorderRadius.circular(0);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        width: 398,
        height: 68,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 0.8,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // أيقونة الصندوق والمعلومات
              Expanded(
                child: Row(
                  children: [
                    // أيقونة الصندوق
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Gap(9),
                    // العمود الذي يحتوي على رقم الوصل والعنوان
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // رقم الوصل
                          Text(
                            receipt.code,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 24 / 14,
                              letterSpacing: 0,
                              color: Color(0xFF8C8C8C),
                            ),
                            textAlign: TextAlign.right,
                          ),
                          // العنوان (الموقع)
                          const Gap(2),
                          Text(
                            receipt.location,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize:12 ,
                             // height:1,
                            //  letterSpacing: 0,
                            wordSpacing:1
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // كاونتر الحالة
              Container(
                constraints: const BoxConstraints(
                  minWidth: 60,
                  maxWidth: 110,
                ),
                height: 28,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusBackgroundColor(receipt.status),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _getStatusBackgroundColor(receipt.status),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusBackgroundColor(receipt.status),
                      offset: const Offset(0, 0),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    receipt.status,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      height: 24 / 14,
                      letterSpacing: 0,
                      color: _getStatusTextColor(receipt.status),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'في المخزن':
        return const Color.fromARGB(255, 224, 238, 250); // #F0F8FF
      case 'قيد الاستحصال':
        return const Color.fromARGB(255, 255, 255, 226); // #FDFDF6
      case 'تم التسليم':
        return const Color.fromARGB(255, 231, 255, 243); // #F7FDFA
      case 'قيد التوصيل':
        return Colors.purple.withOpacity(0.1);
      case 'مؤجل':
        return Colors.grey.withOpacity(0.1);
      case 'راجع':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'في المخزن':
        return const Color(0xFF2A68A3); // #2A68A3
      case 'قيد الاستحصال':
        return const Color(0xFFDDC73C); // #DDC73C
      case 'تم التسليم':
        return const Color(0xFF125438); // #125438
      case 'قيد التوصيل':
        return Colors.purple;
      case 'مؤجل':
        return Colors.grey;
      case 'راجع':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
