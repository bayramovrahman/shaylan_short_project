import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/pages/next_visit_time/parts/end_visit_button.dart';
import 'package:shaylan_agent/pages/next_visit_time/parts/select_date_input.dart';

class NextVisitTimePage extends ConsumerWidget {
  const NextVisitTimePage({
    super.key,
    required this.cardCode,
    required this.visitID,
    required this.afterPayment,
    required this.fromTrader,
  });

  final String cardCode;
  final int visitID;
  final bool afterPayment;
  final bool fromTrader;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    debugPrint("onNextVisitTime");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lang.selectNextVisitTime,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 50),
              SelectDateInput(
                  visitID: visitID,
                  afterPayment: afterPayment,
                  fromTrader: fromTrader),
              const SizedBox(height: 50),
              EndVisitButton(
                visitID: visitID,
                afterPayment: afterPayment,
                fromTrader: fromTrader,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
