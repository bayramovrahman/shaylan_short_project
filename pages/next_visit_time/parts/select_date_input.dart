import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/functions/parts/select_date_input.dart';
import 'package:shaylan_agent/providers/pages/select_next_visit_time.dart';

class SelectDateInput extends ConsumerWidget {
  const SelectDateInput(
      {super.key, required this.visitID, required this.afterPayment, required this.fromTrader});

  final int visitID;
  final bool afterPayment;
  final bool fromTrader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedDate = ref.watch(selectedDateProvider);
    String selectedTime = ref.watch(selectedTimeProvider);

    return ListTile(
      tileColor: Colors.blue,
      onTap: () async =>
          await selectDateTime(context, ref, visitID, afterPayment, fromTrader),
      leading: const Icon(Icons.calendar_month, color: Colors.white),
      title: Text(
        selectedDate.isEmpty || selectedTime.isEmpty
            ? 'Sene we wagt'
            : '$selectedDate ${selectedTime.substring(0, 5)}',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
