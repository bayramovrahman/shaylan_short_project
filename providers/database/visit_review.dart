import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/visit_reviews.dart';
import 'package:shaylan_agent/models/visit_review.dart';

final getVisitReviewsByVisitIDProvider =
    FutureProvider.autoDispose.family<List<VisitReview>, int>(
  (ref, arg) async => await getVisitReviewsByVisitID(arg),
);
