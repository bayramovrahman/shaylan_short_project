import 'package:shaylan_agent/database/functions/merch_product.dart';
import 'package:shaylan_agent/models/merch_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mpdbProvider =
    Provider<MerchProductDBService>((ref) => MerchProductDBService());
final mpDataProvider =
    FutureProvider.family<List<MerchProduct>, String>((ref, name) {
  return ref.read(mpdbProvider).getMPs(name);
});

class MerchProductSearchNotifier extends StateNotifier<String> {
  MerchProductSearchNotifier() : super('');

  void changeSearch(String search) {
    state = search;
  }
}

var mpSearchProvider =
    StateNotifierProvider.autoDispose<MerchProductSearchNotifier, String>(
        (ref) => MerchProductSearchNotifier());
