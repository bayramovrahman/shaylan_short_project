import 'package:shaylan_agent/models/terminal.dart';
import 'package:shaylan_agent/services/database/terminal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final terminalDBProvider =
    Provider<TerminalDBService>((ref) => TerminalDBService());

final getTerminalsProvider = FutureProvider.autoDispose<List<Terminal>>(
  (ref) => ref.read(terminalDBProvider).getTerminals(),
);
