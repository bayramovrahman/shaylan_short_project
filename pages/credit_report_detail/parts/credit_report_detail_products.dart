import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_product_card.dart';
import 'package:shaylan_agent/providers/database/customer_balance_history.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class CreditReportDetailProducts extends ConsumerWidget {
  const CreditReportDetailProducts({super.key, required this.creditReportLine});

  final CreditReportLine creditReportLine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    CustomerBalanceHistoryParams arg = CustomerBalanceHistoryParams(
      docId: creditReportLine.docEntryInv != 0
          ? creditReportLine.docEntryInv
          : creditReportLine.docEntryRin,
      tableName: creditReportLine.docEntryInv != 0
          ? 'customers_invoice_details'
          : 'customers_return_details',
    );

    AsyncValue<ResultCustomerBalanceHistory> resultCustomerBalanceHistory =
        ref.watch(getCustomerBalanceHistoryDetailsByDocIdProvider(arg));

    return resultCustomerBalanceHistory.when(
      data: (data) {
        if (data.customerBalanceHistoryDetails == null ||
            data.customerBalanceHistoryDetails!.isEmpty) {
          return Center(child: Text(lang.noData));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => CreditReportProductCard(
              customerBalanceHistoryDetail:
                  data.customerBalanceHistoryDetails![index]),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: data.customerBalanceHistoryDetails!.length,
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
