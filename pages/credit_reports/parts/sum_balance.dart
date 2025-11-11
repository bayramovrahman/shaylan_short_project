import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';

class SumBalance extends ConsumerWidget {
  const SumBalance({
    super.key,
    required this.creditReportLineGroups,
    required this.cardCode,
  });

  final List<CreditReportLineGroup> creditReportLineGroups;
  final String cardCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    num sumBalance = 0;

    for (CreditReportLineGroup crlg in creditReportLineGroups) {
      for (CreditReportLine crl in crlg.creditReportLines) {
        sumBalance += crl.balance;
      }
    }

    AsyncValue<num> sumVisitPaymentInvoices =
        ref.watch(getSumVisitPaymentInvoicesByCardCodeProvider(cardCode));

    return sumVisitPaymentInvoices.when(
      data: (data) {
        return Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${lang.totalAmountRemainder} :',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.monserratBold,
                    ),
                  ),
                  Text(
                    '${sumBalance.toStringAsFixed(2)} ${lang.manat}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.monserratBold,
                    ),
                  ),
                ],
              ),
              data != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${lang.statusSent} :',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                        Text(
                          '${data.toStringAsFixed(2)} ${lang.manat}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              data != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${lang.remainder} :',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                        Text(
                          '${(sumBalance - data).toStringAsFixed(2)} ${lang.manat}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => const SizedBox.shrink(),
    );
  }
}
