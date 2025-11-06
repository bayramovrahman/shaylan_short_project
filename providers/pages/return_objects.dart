import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadRejectedReturnObjectProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final loadAcceptReturnObjectProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final loadGetHistoryReturnObjectProvider =
    StateProvider.autoDispose<bool>((ref) => true);
