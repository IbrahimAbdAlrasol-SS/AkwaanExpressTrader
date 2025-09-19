import 'package:flutter/material.dart';
import '../enums/receipt_status.dart';

/// ويدجت شارة الحالة للوصولات
class ReceiptStatusBadge extends StatelessWidget {
  final ReceiptStatus status;

  const ReceiptStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ارتفاع ثابت وعرض مرن
      height: 26, // ارتفاع ثابت
      constraints: const BoxConstraints(
        minWidth: 60, // الحد الأدنى للعرض
      ),
      // padding مرن بناءً على طول النص
      padding: EdgeInsets.symmetric(
        horizontal: _getPaddingForText(status.displayName),
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          status.displayName,
          style: TextStyle(
           // fontFamily: 'Alexandria',
            fontWeight: FontWeight.w300,
            fontSize: 14,
            height: 24 / 14,
            color: status.textColor,
          ),
          textAlign: TextAlign.center,
          // منع قطع النص
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
      ),
    );
  }

  /// حساب padding مناسب بناءً على طول النص
  double _getPaddingForText(String text) {
    // النصوص القصيرة تحتاج padding أكبر
    // النصوص الطويلة تحتاج padding أقل
    if (text.length <= 6) {
      return 16.0; // للنصوص القصيرة مثل "جديد"
    } else if (text.length <= 10) {
      return 12.0; // للنصوص المتوسطة مثل "مكتملة"
    } else {
      return 8.0; // للنصوص الطويلة مثل "قيد الاستحصال"
    }
  }
}
