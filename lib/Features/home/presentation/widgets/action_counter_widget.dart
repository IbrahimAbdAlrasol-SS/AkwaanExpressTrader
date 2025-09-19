import 'package:Tosell/Features/home/presentation/widgets/add_receipt_column_widget.dart';
import 'package:Tosell/Features/home/presentation/widgets/counter_divider_widget.dart';
import 'package:Tosell/Features/home/presentation/widgets/invoice_history_column_widget.dart';
import 'package:Tosell/Features/home/presentation/widgets/withdraw_balance_column_widget.dart';
import 'package:flutter/material.dart';

class ActionCounterWidget extends StatelessWidget {
  final VoidCallback? onAddReceiptTap;
  final VoidCallback? onWithdrawBalanceTap;
  final VoidCallback? onInvoiceHistoryTap;

  const ActionCounterWidget({
    super.key,
    this.onAddReceiptTap,
    this.onWithdrawBalanceTap,
    this.onInvoiceHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 398,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // Border Radius/large
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: AddReceiptColumnWidget(
              onTap: onAddReceiptTap,
            ),
          ),
          const CounterDividerWidget(),
          Expanded(
            child: WithdrawBalanceColumnWidget(
              onTap: onWithdrawBalanceTap,
            ),
          ),
          const CounterDividerWidget(),
          Expanded(
            child: InvoiceHistoryColumnWidget(
              onTap: onInvoiceHistoryTap,
            ),
          ),
        ],
      ),
    );
  }
}
