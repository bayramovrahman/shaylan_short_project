import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/methods/pages/credit_reports.dart';
import 'package:shaylan_agent/models/customer_balance_history_detail.dart';

class CustomerBalancePaymentHistoryDetailTableRows extends StatelessWidget {
  const CustomerBalancePaymentHistoryDetailTableRows({
    super.key,
    required this.customerBalancePaymentHistoryDetails,
  });

  final List<CustomerBalancePaymentHistoryDetail> customerBalancePaymentHistoryDetails;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            // 5: FlexColumnWidth(1),
          },
          children: customerBalancePaymentHistoryDetails.map(
            (e) {
              DateTime parsedDate = DateTime.parse(e.docDate);
              String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide()),
                ),
                children: [
                  tableRowMethod(formattedDate),
                  // tableRowMethod(e.cardCode),
                  tableRowMethod(e.cardName),
                  tableRowMethod('${e.sumApplied}\n${lang.manat}'),
                  tableRowMethod('${e.baseRef} '),
                  tableRowMethod('${e.docId} '),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
