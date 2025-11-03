import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/pages/credit_reports.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_history_table_date_header.dart';

class CustomerBalanceHistoryTableHeader extends StatelessWidget {
  const CustomerBalanceHistoryTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.white),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          children: [
            CustomerBalanceHistoryTableDateHeader(text: lang.dateforhistory),
            tableHeaderMethod(lang.paid),
            tableHeaderMethod(lang.totalAmount),
            tableHeaderMethod(lang.remainder),
            tableHeaderMethod("${lang.invoice}\nNo"),
          ],
        ),
      ],
    );
  }
}
