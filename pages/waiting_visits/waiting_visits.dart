import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/home.dart';
import 'package:shaylan_agent/pages/waiting_visits/parts/result_waiting_visits.dart';

class WaitingVisitsPage extends StatelessWidget {
  const WaitingVisitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(lang.waitingVisits),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                ),
                child: Text(
                  lang.main,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: const ResultWaitingVisits(),
      ),
    );
  }
}
