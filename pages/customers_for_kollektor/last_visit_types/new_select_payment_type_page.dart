import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/providers/pages/select_payment_type_for_kollektor.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'new_payment_input_page.dart';

class NewSelectPaymentTypePage extends ConsumerWidget {
  const NewSelectPaymentTypePage({
    super.key,
    required this.creditReportLine,
    required this.visitID,
    required this.cardCode,
  });

  final CreditReportLine creditReportLine;
  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          lang.paymentOption,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PaymentTypeListTile(
              paymentType: VisitPaymentType.nagt,
              title: lang.cashPayment,
            ),
            _PaymentTypeListTile(
              paymentType: VisitPaymentType.terminal,
              title: lang.terminal,
            ),
            _PaymentTypeListTile(
              paymentType: VisitPaymentType.perecesleniya,
              title: lang.enumeration,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.all(15),
                elevation: 6,
              ),
              onPressed: () {
                String selectedPaymentType =
                    ref.read(selectedPaymentTypeProvider);
                if (selectedPaymentType.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Töleg görnüşini saýlaň!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                navigatorPushMethod(
                  context,
                  NewPaymentInputPage(
                    creditReportLine: creditReportLine,
                    visitID: visitID,
                    cardCode: cardCode,
                    paymentType: selectedPaymentType,
                  ),
                  false,
                );
              },
              child: const Text(
                'Dowam et',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTypeListTile extends ConsumerWidget {
  const _PaymentTypeListTile({
    required this.paymentType,
    required this.title,
  });

  final String paymentType, title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedPaymentType = ref.watch(selectedPaymentTypeProvider);
    return Card(
      color: Theme.of(context).primaryColor,
      child: RadioListTile(
        activeColor: Colors.white,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: paymentType,
        groupValue: selectedPaymentType,
        onChanged: (value) =>
            ref.read(selectedPaymentTypeProvider.notifier).state = paymentType,
      ),
    );
  }
}
