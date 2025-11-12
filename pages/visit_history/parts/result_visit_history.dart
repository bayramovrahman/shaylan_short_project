import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/pages/visit_history/parts/visit_history_card.dart';
import 'package:shaylan_agent/providers/database/visit.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class ResultVisitHistory extends ConsumerWidget {
  const ResultVisitHistory({super.key, required this.isTrader});

  final bool isTrader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    AsyncValue<List<VisitModel>> visits = ref.watch(getVisitsProvider);

    return visits.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text(lang.noData));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => VisitHistoryCard(
              visit: data[index],
              isTrader: isTrader,
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(child: Text(lang.anErrorHasOccurred)),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
