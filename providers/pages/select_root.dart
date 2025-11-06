import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedRootProvider = StateProvider.autoDispose<String>((ref) => '');
