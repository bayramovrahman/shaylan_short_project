import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/pages/credit_reports.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/customer_credit_report.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';

class KollektorCustomersTableRows extends ConsumerWidget {
  const KollektorCustomersTableRows({super.key, required this.ccrs});

  final List<CustomerCreditReport> ccrs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
          },
          children: ccrs.map(
            (e) {
              AsyncValue<num> sumVisitPayment = ref.watch(
                  getSumVisitPaymentInvoicesByCardCodeProvider(e.cardCode));

              return sumVisitPayment.when(
                data: (data) {
                  num sumBalance = 0;

                  if (e.sumBalance != null && e.sumBalance != 0) {
                    sumBalance = e.sumBalance!;
                  }

                  if (e.sumBalance != null && e.sumBalance != 0 && data != 0) {
                    sumBalance = e.sumBalance! - data;
                  }

                  return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide()),
                    ),
                    children: [
                      customersTableRowMethod(e.cardName, context, e.cardCode),
                      customersTableRowMethod(
                        sumBalance.toStringAsFixed(2),
                        context,
                        e.cardCode,
                      ),
                      customersTableRowMethod(
                        '${e.expiredDay ?? 0}',
                        context,
                        e.cardCode,
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => const TableRow(
                  children: [
                    SizedBox.shrink(),
                    SizedBox.shrink(),
                    SizedBox.shrink()
                  ],
                ),
                loading: () => const TableRow(
                  children: [
                    SizedBox.shrink(),
                    SizedBox.shrink(),
                    SizedBox.shrink()
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
