import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/models/customer_balance_history_detail.dart';
import 'package:shaylan_agent/pages/customer_balance_payment_history_detail/parts/customer_balance_payment_history_detail_table_header.dart';
import 'package:shaylan_agent/pages/customer_balance_payment_history_detail/parts/customer_balance_payment_history_detail_table_rows.dart';
import 'package:shaylan_agent/providers/database/customer_balance_history.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class ResultCustomerBalancePaymentHistoryDetail extends ConsumerWidget {
  const ResultCustomerBalancePaymentHistoryDetail(
      {super.key, required this.docNum});

  final int docNum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    AsyncValue<ResultCustomerBalanceHistory> resultCustomerBalanceHistory = ref
        .watch(getCustomerBalancePaymentHistoryDetailsByDocIdProvider(docNum));

    return resultCustomerBalanceHistory.when(
      data: (data) {
        if (data.error != '') {
          return Center(child: Text(data.error));
        }

        if (data.customerBalancePaymentHistoryDetails == null ||
            data.customerBalancePaymentHistoryDetails!.isEmpty) {
          return Center(
            child: Text(
              lang.noData,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }

        List<CustomerBalancePaymentHistoryDetail>?
            customerBalancePaymentHistoryDetails =
            data.customerBalancePaymentHistoryDetails!;

        return Column(
          children: [
            const CustomerBalancePaymentHistoryDetailTableHeader(),
            CustomerBalancePaymentHistoryDetailTableRows(
              customerBalancePaymentHistoryDetails:
                  customerBalancePaymentHistoryDetails,
            ),
          ],
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
