import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/visit_history_payments_details/parts/result_visit_history_payments_details.dart';

class VisitHistoryPaymentsDetails extends StatelessWidget {
  const VisitHistoryPaymentsDetails({super.key, required this.visitID});

  final int visitID;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(lang.paymentHistory),
      ),
      body: ResultVisitHistoryPaymentsDetails(visitID: visitID),
    );
  }
}
