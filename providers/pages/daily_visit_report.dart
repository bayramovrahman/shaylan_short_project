import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final startDateProvider = StateProvider.autoDispose<String>(
  (ref) => DateFormat('yyyy-MM-dd').format(DateTime.now()),
);
final endDateProvider = StateProvider.autoDispose<String>(
  (ref) => DateFormat('yyyy-MM-dd').format(DateTime.now()),
);
