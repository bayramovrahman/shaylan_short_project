import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/providers/pages/credit_reports.dart';
import 'package:shaylan_agent/providers/database/credit_report_line.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/sum_balance.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/credit_reports_result.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/credit_report_pay_button.dart';

class CreditReportsPage extends ConsumerWidget {
  const CreditReportsPage({
    super.key,
    required this.cardCode,
    this.visitID,
  });

  final String cardCode;
  final int? visitID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    AsyncValue<List<CreditReportLineGroup>> creditReportLineGroups = ref.watch(getCreditReportLinesByCardCodeProvider(cardCode));
    debugPrint('onCreditReportsPage');
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await ref.read(visitPaymentInvoiceProvider.notifier).removeAllPaid();
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            lang.creditReport,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.monserratBold,
            ),
          ),
          actions: [
            visitID != null
                ? CreditReportPayButton(
                    visitID: visitID!,
                    cardCode: cardCode,
                  )
                : const SizedBox.shrink()
          ],
          leading: IconButton(
            icon: Icon(
              IconlyLight.arrow_left_2,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: creditReportLineGroups.when(
          data: (response) {
            if (response.isEmpty || response.first.creditReportLines.isEmpty) {
              return Center(child: Text(lang.noData));
            }

            return Column(
              children: [
                Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      response.first.creditReportLines.first.client,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SumBalance(
                  creditReportLineGroups: response,
                  cardCode: cardCode,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: response.map(
                      (e) {
                        if (e.creditReportLines.isNotEmpty) {
                          return ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${lang.group} ${e.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.monserratBold,
                                  ),
                                ),
                                Text(
                                  '${e.creditReportLines.length} ${lang.invoice}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.monserratBold,
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              CreditReportsResult(
                                creditReportLines: e.creditReportLines,
                                visitID: visitID,
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ).toList(),
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) => errorMethod(error),
          loading: () => loadWidget,
        ),
      ),
    );
  }
}
