import 'package:flutter_riverpod/flutter_riverpod.dart';

final openCustomersSearchProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final searchCustomerProvider = StateProvider.autoDispose<String>((ref) => '');
final districtFilterProvider = StateProvider.autoDispose<String>((ref) => '');
final sortBalanceProvider = StateProvider.autoDispose<String>((ref) => '');
final sortExpiredDayProvider = StateProvider.autoDispose<String>((ref) => '');
final loadStartVisitProvider = StateProvider.autoDispose<bool>((ref) => false);
