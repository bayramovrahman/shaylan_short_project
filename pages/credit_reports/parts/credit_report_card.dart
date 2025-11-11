import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';
import 'package:shaylan_agent/pages/credit_report_detail/credit_report_detail.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/credit_report_pay_line.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';

class CreditReportCard extends ConsumerWidget {
  const CreditReportCard({super.key, required this.creditReportLine, this.visitID});

  final CreditReportLine creditReportLine;
  final int? visitID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    num docEntry = 0;

    if (creditReportLine.docEntryInv != 0) {
      docEntry = creditReportLine.docEntryInv;
    } else {
      docEntry = creditReportLine.docEntryRin;
    }

    AsyncValue<List<VisitPaymentInvoice>> visitPaymentInvoices =
        ref.watch(getVisitPaymentInvoicesByDocEntryProvider(docEntry));

    return visitPaymentInvoices.when(
      data: (data) {
        num remainSum = 0;
        List<CreditReportDetailListTile> visitPaymentInvoices = [];
        debugPrint(data.length.toString());

        if (data.isNotEmpty) {
          visitPaymentInvoices = data
              .map(
                (e) => CreditReportDetailListTile(
                  text: lang.paid,
                  value: '${e.sumApplied} ${lang.manat}',
                ),
              )
              .toList();

          num sum = 0;
          for (VisitPaymentInvoice element in data) {
            sum += element.sumApplied;
          }

          remainSum = creditReportLine.balance - sum;
        } else {
          remainSum = creditReportLine.balance;
        }

        CreditReportLine crl = creditReportLine.copyWith(balance: remainSum);

        return GestureDetector(
          onTap: () => navigatorPushMethod(
            context,
            CreditReportDetailPage(creditReportLine: creditReportLine),
            false,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Card(
              color: Colors.blue.shade400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CreditReportDetailListTile(
                      text: '${lang.documentNumber}:',
                      value: '${creditReportLine.docNum}',
                    ),
                    CreditReportDetailListTile(
                      text: '${lang.loanAmount}:',
                      value: '${creditReportLine.creditSum} ${lang.manat}',
                    ),
                    CreditReportDetailListTile(
                      text: '${lang.paymentOption}:',
                      value: creditReportLine.paymentType,
                    ),
                    CreditReportDetailListTile(
                      text: '${lang.expiredDay}:',
                      value: '${creditReportLine.expired}',
                    ),
                    CreditReportDetailListTile(
                      text: '${lang.remainder}:',
                      value: '${crl.balance} ${lang.manat}',
                    ),
                    ...visitPaymentInvoices,
                    visitID != null
                        ? CreditReportPayLine(creditReportLine: crl)
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
