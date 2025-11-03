import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/credit_report_pay_button.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/credit_reports_result.dart';
import 'package:shaylan_agent/pages/credit_reports/parts/sum_balance.dart';
import 'package:shaylan_agent/providers/database/credit_report_line.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/providers/pages/credit_reports.dart';

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

    AsyncValue<List<CreditReportLineGroup>> creditReportLineGroups =
        ref.watch(getCreditReportLinesByCardCodeProvider(cardCode));

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
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            lang.creditReport,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            visitID != null
                ? CreditReportPayButton(
                    visitID: visitID!,
                    cardCode: cardCode,
                  )
                : const SizedBox.shrink()
          ],
        ),
        body: creditReportLineGroups.when(
          data: (response) {
            if (response.isEmpty || response.first.creditReportLines.isEmpty) {
              return Center(child: Text(lang.noData));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(
                    response.first.creditReportLines.first.client,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                    textAlign: TextAlign.center,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${lang.group} ${e.name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${e.creditReportLines.length} sany faktura',
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
              ),
            );
          },
          error: (error, stackTrace) => errorMethod(error),
          loading: () => loadWidget,
        ),
      ),
    );
  }
}
