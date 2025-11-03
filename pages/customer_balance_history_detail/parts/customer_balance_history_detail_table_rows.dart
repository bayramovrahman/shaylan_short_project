import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/methods/pages/credit_reports.dart';
import 'package:shaylan_agent/models/customer_balance_history_detail.dart';

class CustomerBalanceHistoryDetailTableRows extends StatelessWidget {
  const CustomerBalanceHistoryDetailTableRows(
      {super.key, required this.customerBalanceHistoryDetails});

  final List<CustomerBalanceHistoryDetail> customerBalanceHistoryDetails;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: customerBalanceHistoryDetails
              .map(
                (e) => TableRow(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide()),
                  ),
                  children: [
                    tableRowMethod(e.itemCode),
                    tableRowMethod(e.itemDescription),
                    tableRowMethod('${e.quantity}'),
                    tableRowMethod('${e.price} ${lang.manat}'),
                    tableRowMethod('${e.lineTotal} ${lang.manat}'),
                    tableRowMethod(e.documentNumber),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
