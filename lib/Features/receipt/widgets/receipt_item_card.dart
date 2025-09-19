import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../models/receipt_update_model.dart';
import '../enums/receipt_status.dart';
import 'receipt_status_badge.dart';

/// ويدجت عنصر الوصل الجديد
class ReceiptItemCard extends StatelessWidget {
  final ReceiptUpdateModel receipt;

  const ReceiptItemCard({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 398,
      height: 130,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(208, 228, 239, 255),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE7E9EC),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // الكونتينر الداخلي
          Container(
            width: 398,
            height: 95,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFF0F0F0),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الجانب الأيسر - أيقونة الصندوق والمعلومات
                Row(
                  children: [
                    // أيقونة الصندوق
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF0F0F0),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF141B34),
                        size: 24,
                      ),
                    ),
                    const Gap(8),
                    // عمود المعلومات
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // رقم الوصل
                       // Gap(5),
                        Text(
                          '#${receipt.code}',
                          style: const TextStyle(
                           // fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            height: 24 / 14,
                            color: Color(0xFF8C8C8C),
                          ),
                        ),
                        // العنوان
                        //Gap(5),
                        Text(
                          receipt.location,
                          style: const TextStyle(
                           // fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            height: 24 / 16,
                            color: Colors.black,
                          ),
                        ),
                      // const Gap(10),
                        // الوقت
                        Text(
                          _formatDeliveryTime(receipt.deliveryTime),
                          style: const TextStyle(
                           // fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            height: 24 / 14,
                            color: Color(0xFF8C8C8C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // الجانب الأيمن - شارة الحالة
                ReceiptStatusBadge(
                  status: ReceiptStatus.fromString(receipt.status),
                ),
              ],
            ),
          ),
          // صف مبلغ الاستحقاق
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'مبلغ الاستحقاق',
                    style: TextStyle(
                   //   fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color.fromARGB(255, 72, 30, 30),
                    ),
                  ),
                  Text(
                    '${NumberFormat('#,###').format(receipt.amount)} د.ع',
                    style: const TextStyle(
                     // fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// تنسيق وقت التسليم بالصيغة المطلوبة
  String _formatDeliveryTime(DateTime dateTime) {
    final arabicFormatter = DateFormat('dd/MM/yyyy', 'en');
    final timeFormatter = DateFormat('h:mm a', 'en');

    final date = arabicFormatter.format(dateTime);
    final time = timeFormatter.format(dateTime);

    return '$date, $time';
  }
}
