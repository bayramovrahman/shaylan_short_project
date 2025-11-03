import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/pages/customer_balance_history/customer_balance_history.dart';
import 'package:shaylan_agent/providers/pages/visit_steps.dart';

class VisitStepOnePage extends ConsumerWidget {
  const VisitStepOnePage({super.key, required this.visitID});

  final int visitID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    bool load = ref.watch(loadStartStepOneProvider);

    debugPrint("onVisitStepOnePage");

    return Scaffold(
      appBar: AppBar(title: Text('${lang.step} 1')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lang.reconciliationOfMutualSettlements,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: load
                  ? null
                  : () async {
                      ref.read(loadStartStepOneProvider.notifier).state = true;

                      VisitStepModel visitStep = VisitStepModel(
                        startTime: DateTime.now().toIso8601String(),
                        name: 'step 1',
                        visitID: visitID,
                        description: lang.reconciliationOfMutualSettlements,
                      );

                      await createVisitStep(visitStep);
                      String cardCode = await getCardCodeByVisitID(visitID);
                      ref.read(loadStartStepOneProvider.notifier).state = false;
                      if (context.mounted) {
                        navigatorPushMethod(
                          context,
                          CustomerBalanceHistoryPage(
                            cardCode: cardCode,
                            visitID: visitID,
                            afterPayment: false,
                          ),
                          false,
                        );
                      }
                    },
              child: load
                  ? SizedBox(height: 25, width: 25, child: loadWidget)
                  : Text(
                      '${lang.startStep} 1',
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
