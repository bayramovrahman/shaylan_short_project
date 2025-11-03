import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_products.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_main_details.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class CreditReportDetailPage extends StatelessWidget {
  const CreditReportDetailPage({super.key, required this.creditReportLine});

  final CreditReportLine creditReportLine;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Credit report detail'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            CreditReportMainDetails(creditReportLine: creditReportLine),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                lang.products,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            CreditReportDetailProducts(creditReportLine: creditReportLine),
          ],
        ),
      ),
    );
  }
}
