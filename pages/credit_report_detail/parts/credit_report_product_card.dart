import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/customer_balance_history_detail.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class CreditReportProductCard extends StatelessWidget {
  const CreditReportProductCard(
      {super.key, required this.customerBalanceHistoryDetail});

  final CustomerBalanceHistoryDetail customerBalanceHistoryDetail;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditReportDetailListTile(
              text: lang.code,
              value: customerBalanceHistoryDetail.itemCode,
            ),
            CreditReportDetailListTile(
              text: lang.name,
              value: customerBalanceHistoryDetail.itemDescription,
            ),
            CreditReportDetailListTile(
              text: lang.quantityforItems,
              value: '${customerBalanceHistoryDetail.quantity} sany',
            ),
            CreditReportDetailListTile(
              text: lang.orderhistoryitemprice,
              value: '${customerBalanceHistoryDetail.price} man',
            ),
            CreditReportDetailListTile(
              text: lang.totalSum,
              value: '${customerBalanceHistoryDetail.lineTotal} man',
            ),
          ],
        ),
      ),
    );
  }
}
