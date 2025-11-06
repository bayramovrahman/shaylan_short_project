import 'package:flutter_riverpod/flutter_riverpod.dart';

final sortDateProvider = StateProvider.autoDispose<String>((ref) => 'DESC');
