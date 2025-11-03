import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/pages/credit_reports.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/kollektor_customers_table_expired_day_head.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/kollektor_customers_table_remain_head.dart';

class KollektorCustomersTableHeader extends StatelessWidget {
  const KollektorCustomersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          children: [
            tableHeaderMethod(lang.customer),
            const KollektorCustomersTableRemainHead(),
            const KollektorCustomersTableExpiredDayHead(),
          ],
        ),
      ],
    );
  }
}
