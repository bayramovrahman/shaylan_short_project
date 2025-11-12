import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/visit_history_payments_details/visit_history_payments_details.dart';

class VisitHistoryDetailsCard extends StatelessWidget {
  const VisitHistoryDetailsCard({super.key, required this.visitStep});

  final VisitStepModel visitStep;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    String nextVisitTime = '';

    if (visitStep.nextVisitTime!.isNotEmpty) {
      List<String> times = visitStep.nextVisitTime!.split('T');
      nextVisitTime = "${times[0]} ${times[1]}";
    }

    return GestureDetector(
      onTap: () {
        if (visitStep.canPay == 'Y') {
          navigatorPushMethod(
            context,
            VisitHistoryPaymentsDetails(visitID: visitStep.visitID),
            false,
          );
        }
      },
      child: Card(
        color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CreditReportDetailListTile(
                text: lang.name,
                value: visitStep.description,
              ),
              CreditReportDetailListTile(
                text: lang.dateforhistory,
                value: DateFormat('dd-MM-yyyy HH:mm')
                    .format(DateTime.parse(visitStep.startTime)),
              ),
              if (visitStep.canPay != null && visitStep.canPay != '')
                CreditReportDetailListTile(
                  text: lang.payment,
                  value: visitStep.canPay == 'N' ? lang.no : lang.yes,
                )
              else
                const SizedBox.shrink(),
              nextVisitTime.isNotEmpty
                  ? CreditReportDetailListTile(
                      text: lang.nextVisitTime,
                      value: nextVisitTime,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
