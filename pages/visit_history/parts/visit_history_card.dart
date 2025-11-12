// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shaylan_agent/methods/gridview.dart';

import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_list_tile.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/visit_history_details/visit_history_details.dart';

class VisitHistoryCard extends ConsumerWidget {
  const VisitHistoryCard({
    super.key,
    required this.visit,
    required this.isTrader,
  });

  final VisitModel visit;
  final bool isTrader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    Color cardColor = Colors.green;

    // Set card color based on status
    if (visit.status == VisitPaymentStatus.dontSent) {
      cardColor = Colors.blue;
    }

    DateTime dateTime = DateTime.parse(visit.startTime.trim());
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

    return GestureDetector(
      onTap: () => navigatorPushMethod(
        context,
        VisitHistoryDetailsPage(visit: visit),
        false,
      ),
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CreditReportDetailListTile(
                text: lang.customer,
                value: visit.cardName,
              ),
              CreditReportDetailListTile(
                text: lang.dateforhistory,
                value: formattedDate,
              ),
              CreditReportDetailListTile(
                text: lang.hasInventor,
                value: visit.hasInventor == 1 ? lang.yes : lang.no,
              ),
              CreditReportDetailListTile(
                text: lang.hasInventorContract,
                value: visit.hasInventorContract == 1 ? lang.yes : lang.no,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
