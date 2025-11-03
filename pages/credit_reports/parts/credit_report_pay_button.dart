import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/payment_credit_report_comment.dart';
import 'package:shaylan_agent/providers/pages/credit_reports.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class CreditReportPayButton extends ConsumerWidget {
  const CreditReportPayButton({
    super.key,
    required this.visitID,
    required this.cardCode,
  });

  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    List<VisitPaymentInvoice> visitPaymentInvoices =
        ref.watch(visitPaymentInvoiceProvider);

    return visitPaymentInvoices.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () => navigatorPushMethod(
                context,
                PaymentCreditReportComment(
                  visitID: visitID,
                  cardCode: cardCode,
                ),
                false,
              ),
              child: Text(
                lang.payment,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
