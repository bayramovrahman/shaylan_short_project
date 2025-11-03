import 'package:flutter/material.dart';
import 'package:shaylan_agent/pages/customer_balance_history_detail/parts/result_customer_balance_history_details.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class CustomerBalanceHistoryDetailPage extends StatelessWidget {
  const CustomerBalanceHistoryDetailPage(
      {super.key, required this.docID, required this.type});

  final String type;
  final int docID;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    String tableName = 'customers_invoice_details';
    String titleText = lang.invoiceHistory;

    if (type == lang.invoice) {
      tableName = 'customers_invoice_details';
      titleText = lang.invoiceHistory;
    } else if (type == lang.returns) {
      tableName = 'customers_return_details';
      titleText = lang.returnHistory;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(titleText),
      ),
      body: ResultCustomerBalanceHistoryDetails(
          docID: docID, tableName: tableName),
    );
  }
}
