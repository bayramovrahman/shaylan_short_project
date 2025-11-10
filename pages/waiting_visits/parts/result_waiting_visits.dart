import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/waiting_visits/parts/waiting_visit_card.dart';
import 'package:shaylan_agent/providers/database/visit.dart';
import 'package:shaylan_agent/providers/pages/visit_steps.dart';

class ResultWaitingVisits extends ConsumerWidget {
  const ResultWaitingVisits({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    AsyncValue<List<VisitModel>> visits = ref.watch(getDontSentVisitsProvider);
    bool loadSendVisit = ref.watch(loadSendVisitrovider);

    return visits.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text(lang.noData));
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    WaitingVisitCard(visit: data[index]),
              ),
            ),
            loadSendVisit ? loadWidget : const SizedBox.shrink(),
          ],
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
