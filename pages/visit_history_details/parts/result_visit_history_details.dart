import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/pages/visit_history_details/parts/visit_history_details_card.dart';
import 'package:shaylan_agent/providers/database/visit.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class ResultVisitHistoryDetails extends ConsumerWidget {
  const ResultVisitHistoryDetails({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    AsyncValue<List<VisitStepModel>> visitSteps =
        ref.watch(getVisitStepsByVisitIDProvider(visit.id!));

    return visitSteps.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text(lang.noData));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) =>
              VisitHistoryDetailsCard(visitStep: data[index]),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
