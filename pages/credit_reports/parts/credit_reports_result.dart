import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/credit_report_card.dart';

class CreditReportsResult extends StatelessWidget {
  const CreditReportsResult(
      {super.key, required this.creditReportLines, this.visitID});

  final List<CreditReportLine> creditReportLines;
  final int? visitID;

  @override
  Widget build(BuildContext context) {


    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: creditReportLines
          .map((e) => CreditReportCard(creditReportLine: e, visitID: visitID))
          .toList(),
    );
  }
}
