import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/models/customer_balance_history_detail.dart';
import 'package:shaylan_agent/pages/customer_balance_history_detail/parts/customer_balance_history_detail_table_header.dart';
import 'package:shaylan_agent/pages/customer_balance_history_detail/parts/customer_balance_history_detail_table_rows.dart';
import 'package:shaylan_agent/providers/database/customer_balance_history.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class ResultCustomerBalanceHistoryDetails extends ConsumerWidget {
  const ResultCustomerBalanceHistoryDetails(
      {super.key, required this.docID, required this.tableName});

  final String tableName;
  final int docID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    CustomerBalanceHistoryParams arg = CustomerBalanceHistoryParams(
      docId: docID,
      tableName: tableName,
    );
    AsyncValue<ResultCustomerBalanceHistory>
        resultCustomerBalanceHistoryDetails =
        ref.watch(getCustomerBalanceHistoryDetailsByDocIdProvider(arg));

    return resultCustomerBalanceHistoryDetails.when(
      data: (data) {
        if (data.error != '') {
          return Center(child: Text(data.error));
        }

        if (data.customerBalanceHistoryDetails == null ||
            data.customerBalanceHistoryDetails!.isEmpty) {
          return Center(
            child: Text(
              lang.noData,
              style: const TextStyle(fontSize: 20),
            ),
          );
        }

        List<CustomerBalanceHistoryDetail> customerBalanceHistoryDetails =
            data.customerBalanceHistoryDetails!;

        return Column(
          children: [
            const CustomerBalanceHistoryDetailTableHeader(),
            CustomerBalanceHistoryDetailTableRows(
              customerBalanceHistoryDetails: customerBalanceHistoryDetails,
            ),
          ],
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
