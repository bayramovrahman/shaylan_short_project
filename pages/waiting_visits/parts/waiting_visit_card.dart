import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/waiting_visits/parts/send_visit_button.dart';

class WaitingVisitCard extends StatelessWidget {
  const WaitingVisitCard({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Card(
      color: (visit.unsend ?? true) ? Colors.red : Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CreditReportDetailListTile(
              text: lang.customer,
              value: visit.cardName,
            ),
            CreditReportDetailListTile(
              text: lang.dateforhistory,
              value: DateFormat('dd-MM-yyyy HH:mm')
                  .format(DateTime.parse(visit.startTime)),
            ),
            SendVisitButton(visitID: visit.id!),
          ],
        ),
      ),
    );
  }
}
