import 'package:flutter/material.dart';
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
        height: 65,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
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
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
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
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              height: 24 / 14,
                              letterSpacing: 0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          // العنوان (الموقع)
                          Text(
                            receipt.location,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                            textAlign: TextAlign.right,
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
                  color: _getStatusColor(receipt.status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(receipt.status).withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor(receipt.status).withOpacity(0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
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
                      color: _getStatusColor(receipt.status),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'في المخزن':
        return const Color(0xFFF0F8FF); // #F0F8FF
      case 'قيد الاستحصال':
        return const Color(0xFFFDFDF6); // #FDFDF6
      case 'تم التسليم':
        return const Color(0xFFF7FDFA); // #F7FDFA
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
