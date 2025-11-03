import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/methods/pages/customer_balance_history.dart';
import 'package:shaylan_agent/providers/pages/customer_balance_history.dart';

class CustomerBalanceHistoryTableRows extends ConsumerWidget {
  const CustomerBalanceHistoryTableRows({
    super.key,
    required this.customerBalanceHistories,
    required this.type,
  });

  final List<CustomerBalanceHistory> customerBalanceHistories;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String sortDate = ref.watch(sortDateProvider);
    var lang = AppLocalizations.of(context)!;

    switch (sortDate) {
      case 'ASC':
        customerBalanceHistories.sort((a, b) {
          DateTime dateA = DateTime.parse(a.documentDate);
          DateTime dateB = DateTime.parse(b.documentDate);
          return dateA.compareTo(dateB);
        });
        break;
      case 'DESC':
        customerBalanceHistories.sort((a, b) {
          DateTime dateA = DateTime.parse(a.documentDate);
          DateTime dateB = DateTime.parse(b.documentDate);
          return dateB.compareTo(dateA);
        });
        break;
      default:
    }

    return SingleChildScrollView(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(),
        children: customerBalanceHistories.map(
          (e) {
            DateTime parsedDate = DateTime.parse(e.documentDate);
            String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

            return TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide()),
              ),
              children: [
                customerBalanceHistoryTableRowMethod(
                  formattedDate,
                  context,
                  e.docId,
                  e.documentNumber,
                  type,
                ),
                customerBalanceHistoryTableRowMethod(
                  '${e.paidAmount}\n${lang.manat}',
                  context,
                  e.docId,
                  e.documentNumber,
                  type,
                ),
                customerBalanceHistoryTableRowMethod(
                  '${e.totalAmount}\n${lang.manat}',
                  context,
                  e.docId,
                  e.documentNumber,
                  type,
                ),
                customerBalanceHistoryTableRowMethod(
                  '${e.balanceDue}\n${lang.manat}',
                  context,
                  e.docId,
                  e.documentNumber,
                  type,
                ),
                customerBalanceHistoryTableRowMethod(
                  '${e.documentNumber}',
                  context,
                  e.docId,
                  e.documentNumber,
                  type,
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
