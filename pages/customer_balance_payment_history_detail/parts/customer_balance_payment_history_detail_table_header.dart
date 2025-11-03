import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/pages/credit_reports.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class CustomerBalancePaymentHistoryDetailTableHeader extends StatelessWidget {
  const CustomerBalancePaymentHistoryDetailTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.white),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        // 5: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          children: [
            tableHeaderMethod(lang.dateforhistory),
            // tableHeaderMethod(lang.description),
            tableHeaderMethod(lang.customer),
            tableHeaderMethod(lang.totalSum),
            tableHeaderMethod(lang.invoice),
            tableHeaderMethod(lang.documentNumber),
          ],
        ),
      ],
    );
  }
}
