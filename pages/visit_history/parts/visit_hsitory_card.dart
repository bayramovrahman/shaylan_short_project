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
import 'package:shaylan_agent/screens/visit_history_screen/visit_history_screen.dart';

class VisitHsitoryCard extends ConsumerWidget {
  const VisitHsitoryCard(
      {super.key, required this.visit, required this.isTrader});

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
      onTap: () => isTrader
          ? navigatorPushMethod(
              context,
              ParentStepsPage(
                visitId: visit.id!,
              ),
              false)
          : navigatorPushMethod(
              context, VisitHistoryDetailsPage(visit: visit), false),
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts height based on content
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
              // if (visit.status == VisitPaymentStatus.dontSent)
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: ElevatedButton(
              //     onPressed: () async {
              //       // Add your button logic here
              //       debugPrint(visit.id!.toString());

              //       List<OrderForServer> orders = [];
              //       OrderForServer? order = await getOrder(visit.id!);
              //       orders.add(order!);

              //       // debugPrint(orders.first.toJson().toString());
              //       // User user = await getUser();
              //       // VisitModel visitToSend = visit.copyWith(
              //       //     empID: user.empId,
              //       //     empName: user.firstName,
              //       //     empLastName: user.lastName,
              //       //     endTime: DateTime.now().toIso8601String(),
              //       //     visitType: 'visit_trader',
              //       //     orderList: orders);

              //       // VisitModel visitToSend = visit.copyWith(orderQueuesList: orders);
              //       // String token = ref.read(tokenProvider);
              //       // await sendVisit(visitToSend, token, context);
              //       // debugPrint(visit.toJson().toString());

              //       debugPrint(
              //           "Send button pressed for visit ID: ${visit.id}");
              //     },
              //     child: Text('Wizit ugrat'), // Localized text for "Send"
              //   ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
