import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/models/visit_step.dart';




final getDontSentVisitsProvider = FutureProvider.autoDispose<List<VisitModel>>(
  (ref) async => await getDontSentVisits(),
);

final getVisitStepsByVisitIDProvider =
    FutureProvider.autoDispose.family<List<VisitStepModel>, int>(
  (ref, arg) async => await getVisitStepsByVisitID(arg),
);



class VisitNotifier extends StateNotifier<AsyncValue<List<VisitModel>>> {
  VisitNotifier() : super(const AsyncValue.loading()) {
    _fetchVisits();
  }

  Future<void> _fetchVisits() async {
    try {
      final visits = await getVisits();
      state = AsyncValue.data(visits);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _fetchVisits();
  }
}

final getVisitsProvider = StateNotifierProvider<VisitNotifier, AsyncValue<List<VisitModel>>>(
  (ref) => VisitNotifier(),
);
