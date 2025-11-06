import 'package:flutter/material.dart';
import 'package:shaylan_agent/main.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/terminal.dart';
import 'package:shaylan_agent/providers/database/terminal.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class TerminalsPage extends ConsumerWidget {
  const TerminalsPage({super.key, required this.isAfterLogin});

  final bool isAfterLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Terminal>> terminals = ref.watch(getTerminalsProvider);
    String selectedTerminal = ref.watch(selectedTerminalProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(AppLocalizations.of(context)!.selectTerminal),
        backgroundColor: Colors.white,
      ),
      body: terminals.when(
        data: (response) {
          return ListView.builder(
            itemCount: response.length,
            itemBuilder: (context, index) {
              Terminal terminal = response[index];
              return ListTile(
                title: Text('${terminal.itemName} ${terminal.itemCode}'),
                subtitle: Text('${terminal.assetGroup} ${terminal.assetSerNo}'),
                trailing: selectedTerminal == terminal.assetSerNo
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () => ref
                    .read(selectedTerminalProvider.notifier)
                    .update(terminal.assetSerNo),
              );
            },
          );
        },
        error: (error, stackTrace) => errorMethod(error),
        loading: () => loadWidget,
      ),
      floatingActionButton: isAfterLogin && selectedTerminal != ''
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () =>
                  navigatorPushMethod(context, const MyApp(), true),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            )
          : null,
    );
  }
}
