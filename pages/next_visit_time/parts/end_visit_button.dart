import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/pages/send/sendqueuewidgets/tradingqueue.dart';
import 'package:shaylan_agent/pages/waiting_visits/waiting_visits.dart';

class EndVisitButton extends ConsumerWidget {
  const EndVisitButton({
    super.key,
    required this.visitID,
    required this.afterPayment,
    required this.fromTrader,
  });

  final int visitID;
  final bool afterPayment;
  final bool fromTrader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      onPressed: () async {
        String currentTime = DateTime.now().toIso8601String();

        if (afterPayment) {
          await setEndTimeToVisitStep(visitID, 'step 5', currentTime);
        } else {
          if (fromTrader) {
            await setEndTimeToVisitStep(
                visitID, 'traderVisitended', currentTime);
          } else {
            await setEndTimeToVisitStep(visitID, 'step 2', currentTime);
          }
        }

        await setEndTimeToVisit(visitID);
        if (context.mounted) {
          navigatorPushMethod(
              context,
              fromTrader ? SendQueueProgress() : const WaitingVisitsPage(),
              false);
        }
      },
      child: Text(
        lang.endVisit,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
