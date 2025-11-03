import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/customer_balance_payment_history_detail/parts/result_customer_balance_payment_history_detail.dart';

class CustomerBalancePaymentHistoryDetailPage extends StatelessWidget {
  const CustomerBalancePaymentHistoryDetailPage(
      {super.key, required this.docNum});

  final int docNum;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(lang.paymentHistory),
      ),
      body: ResultCustomerBalancePaymentHistoryDetail(docNum: docNum),
    );
  }
}
