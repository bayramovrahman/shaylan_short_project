import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedPaymentTypeProvider =
    StateProvider.autoDispose<String>((ref) => 'cash');
