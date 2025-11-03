import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/pages/next_visit_time/next_visit_time.dart';
import 'package:shaylan_agent/pages/select_payment_type_for_kollektor/select_payment_type_for_kollektor.dart';

class PaymentCreditForKollektorPage extends StatelessWidget {
  const PaymentCreditForKollektorPage({
    super.key,
    required this.cardCode,
    required this.visitID,
  });

  final String cardCode;
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
        title: Text(lang.workOnSpecialTasks),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${lang.canTheCustomerMakePayment} ?',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaymentCreditForKollektorButtons(
                  text: lang.yes,
                  onPressed: () async {
                    await setCanPayToVisitStep(visitID, 'step 2', 'Y');

                    String currentTime = DateTime.now().toIso8601String();
                    await setEndTimeToVisitStep(visitID, 'step 2', currentTime);

                    VisitStepModel visitStep = VisitStepModel(
                      startTime: DateTime.now().toIso8601String(),
                      name: 'step 3',
                      visitID: visitID,
                      description: lang.collectionOfPayment,
                    );
                    await createVisitStep(visitStep);

                    if (context.mounted) {
                      navigatorPushMethod(
                        context,
                        SelectPaymentTypeForKollektorPage(
                          cardCode: cardCode,
                          visitID: visitID,
                        ),
                        false,
                      );
                    }
                  },
                ),
                const SizedBox(width: 50),
                PaymentCreditForKollektorButtons(
                  text: lang.no,
                  onPressed: () => navigatorPushMethod(
                    context,
                    NextVisitTimePage(
                      cardCode: cardCode,
                      visitID: visitID,
                      afterPayment: false,
                      fromTrader: false,
                    ),
                    false,
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

class PaymentCreditForKollektorButtons extends StatelessWidget {
  const PaymentCreditForKollektorButtons(
      {super.key, required this.text, required this.onPressed});

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
