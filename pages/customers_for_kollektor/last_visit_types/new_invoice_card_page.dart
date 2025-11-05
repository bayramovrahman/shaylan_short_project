import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'new_select_payment_type_page.dart';

class NewInvoiceCard extends StatelessWidget {
  const NewInvoiceCard({
    super.key,
    required this.creditReportLine,
    required this.visitID,
    required this.cardCode,
  });

  final CreditReportLine creditReportLine;
  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Card(
      color: Colors.green,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              lang.documentNumber,
              '${creditReportLine.docNum}',
              Colors.white,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              lang.loanAmount,
              '${creditReportLine.creditSum} man',
              Colors.white,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              lang.paymentOption,
              creditReportLine.paymentType,
              Colors.white,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              lang.expiredDay,
              '${creditReportLine.expired}',
              Colors.white,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              lang.remainder,
              '${creditReportLine.balance} man',
              Colors.white,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  navigatorPushMethod(
                    context,
                    NewSelectPaymentTypePage(
                      creditReportLine: creditReportLine,
                      visitID: visitID,
                      cardCode: cardCode,
                    ),
                    false,
                  );
                },
                child: Text(
                  lang.payment,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }
}
