import 'package:flutter/material.dart';

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
    return IntrinsicHeight(
      child: Row(
        children: [
          // العمود الأول - المستحقات
          Expanded(
            child: _buildReceivablesColumn(),
          ),
          // الفاصل العمودي
          _buildVerticalDivider(),
          // العمود الثاني - الديون
          Expanded(
            child: _buildDebtsColumn(),
          ),
        ],
      ),
    );
  }

  // العمود الأول - المستحقات
  Widget _buildReceivablesColumn() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // نص المستحقات
          const Text(
            'المستحقات',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1.0,
              letterSpacing: 0,
              color: Colors.white70,
            ),
            textAlign: TextAlign.left,
          ),
          // المبلغ مع العلامة الموجبة
          RichText(
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            text: TextSpan(
              children: [
                TextSpan(
                  text: receivablesAmount,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const TextSpan(
                  text: ' + ',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const TextSpan(
                  text: 'د.ع',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // العمود الثاني - الديون
  Widget _buildDebtsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // نص الديون
        const Text(
          'الديون',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 1.0,
            letterSpacing: 0,
            color: Colors.white70,
          ),
          textAlign: TextAlign.left,
        ),
        // المبلغ مع العلامة السالبة
        RichText(
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          text: TextSpan(
            children: [
              TextSpan(
                text: debtsAmount,
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const TextSpan(
                text: ' - ',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const TextSpan(
                text: 'د.ع',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // الفاصل العمودي
  Widget _buildVerticalDivider() {
    return Transform.rotate(
      angle: -90 * 3.14159 / 180, // تحويل -90 درجة إلى راديان
      child: Container(
        width: 66,
        height: 1,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
      ),
    );
  }
}
