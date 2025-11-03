import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/customer.dart';
import 'package:shaylan_agent/models/customer_credit_report.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/kollektor_customers_table_header.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/kollektor_customers_table_rows.dart';
import 'package:shaylan_agent/providers/database/customer.dart';

class ResultCustomersForKollektor extends ConsumerWidget {
  const ResultCustomersForKollektor({super.key, this.root});

  final String? root;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<ResultCustomer> resultCustomer =
        ref.watch(getCustomersWithCreditReportProvider(root ?? ''));

    return resultCustomer.when(
      data: (response) {
        if (response.error != '') {
          return errorMethod(response.error);
        }

        List<CustomerCreditReport> ccrs = response.ccrs!;
        return Padding(
          padding: const EdgeInsets.only(left: 5, top: 10, right: 5),
          child: Column(
            children: [
              const KollektorCustomersTableHeader(),
              KollektorCustomersTableRows(ccrs: ccrs),
            ],
          ),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
