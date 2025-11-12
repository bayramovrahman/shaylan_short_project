import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class VisitHistoryPaymentsDetailsCard extends StatelessWidget {
  const VisitHistoryPaymentsDetailsCard({super.key, required this.payment});

  final VisitPayment payment;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    String paymentType = '';
    Color cardColor = Theme.of(context).primaryColor;

    switch (payment.status) {
      case VisitPaymentStatus.dontSent:
        cardColor = Colors.red;
        break;
      case VisitPaymentStatus.sent:
        cardColor = Colors.blue;
        break;
      case VisitPaymentStatus.draft:
        cardColor = Colors.orangeAccent;
        break;
      case VisitPaymentStatus.accept:
        cardColor = Colors.green;
        break;
      default:
        cardColor = Theme.of(context).primaryColor;
    }

    switch (payment.paymentType) {
      case VisitPaymentType.nagt:
        paymentType = lang.cashPayment;
        break;
      case VisitPaymentType.terminal:
        paymentType = lang.terminal;
        break;
      case VisitPaymentType.perecesleniya:
        paymentType = lang.enumeration;
        break;
      default:
        paymentType = '';
    }

    return Card(
      color: cardColor,
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Column(
          children: [
            CreditReportDetailListTile(
              text: 'Kassa',
              value: payment.cashAccount,
            ),
            CreditReportDetailListTile(
              text: lang.totalSum,
              value: '${payment.paySum} man',
            ),
            CreditReportDetailListTile(
              text: lang.paymentOption,
              value: paymentType,
            ),
            if (payment.terminalNumber != null &&
                payment.paymentType == VisitPaymentType.terminal)
              CreditReportDetailListTile(
                text: lang.terminal,
                value: '${payment.terminalNumber}',
              )
            else
              const SizedBox.shrink(),
            if (payment.checkNumber != 0 &&
                payment.paymentType == VisitPaymentType.terminal)
              CreditReportDetailListTile(
                text: lang.checkNumber,
                value: '${payment.checkNumber}',
              )
            else
              const SizedBox.shrink(),
            payment.comment.isNotEmpty
                ? CreditReportDetailListTile(
                    text: lang.comment,
                    value: payment.comment,
                  )
                : const SizedBox.shrink(),
          ],
        ),
        children: payment.invoices != null || payment.invoices!.isNotEmpty
            ? payment.invoices!.map(
                (e) {
                  return Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          CreditReportDetailListTile(
                            text: lang.documentNumber,
                            value: '${e.docEntry}',
                          ),
                          CreditReportDetailListTile(
                            text: lang.orderSum,
                            value: '${e.sumApplied} man',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList()
            : [],
      ),
    );
  }
}
