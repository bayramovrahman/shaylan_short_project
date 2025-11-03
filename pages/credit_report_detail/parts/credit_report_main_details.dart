import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class CreditReportMainDetails extends StatelessWidget {
  const CreditReportMainDetails({super.key, required this.creditReportLine});

  final CreditReportLine creditReportLine;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Card(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Column(
          children: [
            CreditReportDetailListTile(
              text: '${lang.tradingAgent} :',
              value: creditReportLine.agent,
            ),
            CreditReportDetailListTile(
              text: '${lang.dateforhistory} :',
              value: creditReportLine.deliveriDate,
            ),
            CreditReportDetailListTile(
              text: '${lang.paymentOption} :',
              value: creditReportLine.paymentType,
            ),
            CreditReportDetailListTile(
              text: '${lang.totalSum} :',
              value: '${creditReportLine.creditSum}',
            ),
          ],
        ),
      ),
    );
  }
}
