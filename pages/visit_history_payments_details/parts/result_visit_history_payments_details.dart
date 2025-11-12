import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/pages/visit_history_payments_details/parts/visit_history_payments_details_card.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class ResultVisitHistoryPaymentsDetails extends ConsumerWidget {
  const ResultVisitHistoryPaymentsDetails({super.key, required this.visitID});

  final int visitID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    AsyncValue<List<VisitPayment>> visitPayments =
        ref.watch(getVisitPaymentsByVisitIDProvider(visitID));

    return visitPayments.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text(lang.noData));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) =>
                VisitHistoryPaymentsDetailsCard(payment: data[index]),
          ),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
