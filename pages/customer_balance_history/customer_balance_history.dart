import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/pages/credit_reports/credit_reports.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/result_customer_balance_histories.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/start_visit_step_two_button.dart';

class CustomerBalanceHistoryPage extends StatelessWidget {
  const CustomerBalanceHistoryPage({
    super.key,
    required this.cardCode,
    required this.visitID,
    required this.afterPayment,
  });

  final String cardCode;
  final int visitID;
  final bool afterPayment;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(lang.customerBalanceHistory),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => navigatorPushMethod(
              context,
              CreditReportsPage(
                cardCode: cardCode,
              ),
              false,
            ),
            child: const Icon(Icons.receipt_long, color: Colors.white),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ResultCustomerBalanceHistories(cardCode: cardCode),
      floatingActionButton: StartVisitStepTwoButton(
        cardCode: cardCode,
        visitID: visitID,
        afterPayment: afterPayment,
      ),
    );
  }
}
