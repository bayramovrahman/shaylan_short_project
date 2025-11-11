import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/credit_report_pay_input.dart';

class CreditReportPayLine extends StatelessWidget {
  const CreditReportPayLine({super.key, required this.creditReportLine});

  final CreditReportLine creditReportLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Text(
            'Tolenjek pul',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.monserratBold,
            ),
          ),
        ),
        const SizedBox(width: 50),
        Expanded(
          child: SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreditReportPayInput(creditReportLine: creditReportLine),
                const SizedBox(width: 10),
                Text(
                  AppLocalizations.of(context)!.manat,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.monserratBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
