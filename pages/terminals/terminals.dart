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
          Terminal? currentTerminal;
          if (selectedTerminal.isNotEmpty) {
            final matches = response
                .where((terminal) => terminal.assetSerNo == selectedTerminal)
                .toList();
            if (matches.isNotEmpty) {
              currentTerminal = matches.first;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentTerminal != null) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                      color: Colors.blue.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saýlanan terminal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${currentTerminal.itemName} (${currentTerminal.itemCode})',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currentTerminal.assetGroup} • ${currentTerminal.assetSerNo}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Terminaly üýtgetmek üçin aşakdaky sanawdan täzeden saýlaň.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Text(
                    'Terminal saýlanmady',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              Expanded(
                child: ListView.builder(
                  itemCount: response.length,
                  itemBuilder: (context, index) {
                    Terminal terminal = response[index];
                    return RadioListTile<String>(
                      value: terminal.assetSerNo,
                      groupValue:
                          selectedTerminal.isEmpty ? null : selectedTerminal,
                      title: Text('${terminal.itemName} ${terminal.itemCode}'),
                      subtitle:
                          Text('${terminal.assetGroup} ${terminal.assetSerNo}'),
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) => ref
                          .read(selectedTerminalProvider.notifier)
                          .update(value ?? ''),
                    );
                  },
                ),
              ),
            ],
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
