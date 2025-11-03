import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/pages/customer_balance_history/customer_balance_history.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';
import 'package:shaylan_agent/providers/pages/credit_reports.dart';

class ContinuePay extends ConsumerWidget {
  const ContinuePay({
    super.key,
    required this.visitID,
    required this.cardCode,
  });

  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    debugPrint("onContinuePay");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              lang.doYouContinueToPay,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await ref
                        .read(visitPaymentInvoiceProvider.notifier)
                        .removeAllPaid();
                    String currentTime = DateTime.now().toIso8601String();
                    await setEndTimeToVisitStep(visitID, 'step 3', currentTime);

                    VisitStepModel visitStep = VisitStepModel(
                      startTime: currentTime,
                      name: 'step 4',
                      visitID: visitID,
                      description: lang.paymentReconciliation,
                    );
                    await createVisitStep(visitStep);

                    ref.invalidate(getVisitPaymentsByCardCodeProvider);
                    ref.invalidate(getVisitPaymentInvoicesByCardCodeProvider);
                    ref.invalidate(getVisitPaymentInvoicesByDocEntryProvider);
                    ref.invalidate(
                        getSumVisitPaymentInvoicesByCardCodeProvider);

                    if (context.mounted) {
                      navigatorPushMethod(
                        context,
                        CustomerBalanceHistoryPage(
                          cardCode: cardCode,
                          visitID: visitID,
                          afterPayment: true,
                        ),
                        false,
                      );
                    }
                  },
                  child: Text(
                    lang.no,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 50),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    ref.invalidate(getVisitPaymentsByCardCodeProvider);
                    ref.invalidate(getVisitPaymentInvoicesByCardCodeProvider);
                    ref.invalidate(getVisitPaymentInvoicesByDocEntryProvider);
                    ref.invalidate(
                        getSumVisitPaymentInvoicesByCardCodeProvider);

                    await ref
                        .read(visitPaymentInvoiceProvider.notifier)
                        .removeAllPaid();
                    if (context.mounted) {
                      Navigator.of(context)
                        ..pop()
                        ..pop();
                    }
                  },
                  child: Text(
                    lang.yes,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
