import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/models/visit_review.dart';
import 'package:shaylan_agent/pages/visit_history_details/parts/visit_history_review_card.dart';
import 'package:shaylan_agent/providers/database/visit_review.dart';

class VisitHistoryReviews extends ConsumerWidget {
  const VisitHistoryReviews({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<VisitReview>> visitReviews =
        ref.watch(getVisitReviewsByVisitIDProvider(visit.id!));

    return visitReviews.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) =>
              VisitHistoryReviewCard(review: data[index]),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
