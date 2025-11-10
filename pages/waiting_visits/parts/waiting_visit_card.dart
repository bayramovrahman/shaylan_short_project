import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/pages/waiting_visits/parts/send_visit_button.dart';
import 'package:shaylan_agent/pages/waiting_visits/parts/visit_detail_page.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';

class WaitingVisitCard extends StatelessWidget {
  const WaitingVisitCard({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: InkWell(
        onTap: () {
          navigatorPushMethod(
            context,
            VisitDetailPage(visit: visit),
            false,
          );
        },
        child: Card(
          color: (visit.unsend ?? true) ? Colors.red : Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CreditReportDetailListTile(
                  text: "${lang.customer}:",
                  value: visit.cardName,
                ),
                CreditReportDetailListTile(
                  text: "${lang.dateforhistory}:",
                  value: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(visit.startTime)),
                ),
                SizedBox(height: 10.h),
                SendVisitButton(visitID: visit.id!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
