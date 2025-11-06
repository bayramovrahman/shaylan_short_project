import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedDateProvider = StateProvider.autoDispose<String>((ref) => '');
final selectedTimeProvider = StateProvider.autoDispose<String>((ref) => '');
