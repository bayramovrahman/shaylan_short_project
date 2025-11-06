import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadStartStepOneProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final loadSendVisitrovider = StateProvider.autoDispose<bool>((ref) => false);
