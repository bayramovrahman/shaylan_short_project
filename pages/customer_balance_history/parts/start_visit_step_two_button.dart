import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/pages/next_visit_time/next_visit_time.dart';
import 'package:shaylan_agent/pages/payment_credit_for_kollektor.dart';

class StartVisitStepTwoButton extends StatelessWidget {
  const StartVisitStepTwoButton({
    super.key,
    required this.cardCode,
    required this.visitID,
    required this.afterPayment,
  });

  final String cardCode;
  final int visitID;
  final bool afterPayment;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    debugPrint("onStartVisitStepTwo");

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      onPressed: afterPayment
          ? () async {
              String currentTime = DateTime.now().toIso8601String();
              await setEndTimeToVisitStep(visitID, 'step 4', currentTime);

              VisitStepModel visitStep = VisitStepModel(
                startTime: currentTime,
                name: 'step 5',
                visitID: visitID,
                description: lang.planForTheNextVisit,
              );
              await createVisitStep(visitStep);

              if (context.mounted) {
                navigatorPushMethod(
                  context,
                  NextVisitTimePage(
                    cardCode: cardCode,
                    visitID: visitID,
                    afterPayment: afterPayment,
                    fromTrader: false,
                  ),
                  false,
                );
              }
            }
          : () async {
              String currentTime = DateTime.now().toIso8601String();
              await setEndTimeToVisitStep(visitID, 'step 1', currentTime);

              VisitStepModel visitStep = VisitStepModel(
                startTime: currentTime,
                name: 'step 2',
                visitID: visitID,
                description: lang.workOnSpecialTasks,
              );
              await createVisitStep(visitStep);

              if (context.mounted) {
                navigatorPushMethod(
                  context,
                  PaymentCreditForKollektorPage(
                    cardCode: cardCode,
                    visitID: visitID,
                  ),
                  false,
                );
              }
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            afterPayment ? 'Indiki adim' : '${lang.startStep} 2',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}
