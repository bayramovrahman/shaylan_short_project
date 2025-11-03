import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/providers/pages/select_next_visit_time.dart';
// import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

Future<void> selectDateTime(BuildContext context, WidgetRef ref, int visitID,
    bool afterPayment, bool fromTrader) async {
  String selectedTime = '';

  String selectedDate = await selectDate(context, ref, DateTime.now());
  if (context.mounted) {
    selectedTime = await selectTime(context, ref);
  }

  if (afterPayment) {
    await setNextVisitTimeAndEndTimeToVisitStep(
      visitID,
      'step 5',
      '${selectedDate}T$selectedTime',
    );
    await setCanPayToVisitStep(visitID, 'step 5', 'Y');
  } else {
    if (fromTrader) {
      setNextVisitTimeForTraders(visitID, '${selectedDate}T$selectedTime');
    } else {
      await setNextVisitTimeAndEndTimeToVisitStep(
        visitID,
        'step 2',
        '${selectedDate}T$selectedTime',
      );
      await setCanPayToVisitStep(visitID, 'step 2', 'N');
    }
  }
}

Future<String> selectDate(
    BuildContext context, WidgetRef ref, DateTime firstDate) async {
  var lang = AppLocalizations.of(context)!;

  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: firstDate,
    lastDate: DateTime(2100),
    helpText: lang.selectDate,
    cancelText: lang.no,
    confirmText: 'OK',
    locale: const Locale('ru', 'RU'),
  );

  String formattedDateString = DateFormat('yyyy-MM-dd').format(selectedDate!);
  ref.read(selectedDateProvider.notifier).state = formattedDateString;
  return formattedDateString;
}

Future<String> selectTime(BuildContext context, WidgetRef ref) async {
  var lang = AppLocalizations.of(context)!;

  TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: lang.selectDate,
    cancelText: lang.no,
    confirmText: 'OK',
  );

  if (selectedTime != null && context.mounted) {
    String time = selectedTime.format(context).toString();
    ref.read(selectedTimeProvider.notifier).state = '$time:00.000000';
    return time;
  }
  return '';
}
