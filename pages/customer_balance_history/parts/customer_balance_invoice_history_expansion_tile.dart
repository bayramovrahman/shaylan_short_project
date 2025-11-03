import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_history_table_header.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_history_table_rows.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';

class CustomerBalanceInvoiceHistoryExpansionTile extends ConsumerWidget {
  const CustomerBalanceInvoiceHistoryExpansionTile({
    super.key,
    required this.cbhg,
    required this.cardCode,
  });

  final CustomerBalanceHistoryGroup cbhg;
  final String cardCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<CustomerBalanceHistory> customerBalanceHistories = [];

    AsyncValue<List<CustomerBalanceHistory>> cbhs =
        ref.watch(getVisitPaymentInvoicesByCardCodeProvider(cardCode));

    return cbhg.customerBalanceHistories.isNotEmpty
        ? ExpansionTile(
            iconColor: Colors.black,
            title: Text(
              cbhg.movementType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.monserratBold,
              ),
            ),
            children: [
              const CustomerBalanceHistoryTableHeader(),
              cbhs.when(
                data: (data) {
                  if (data.isNotEmpty) {
                    customerBalanceHistories = [
                      ...cbhg.customerBalanceHistories,
                      ...data
                    ];
                  } else {
                    customerBalanceHistories = cbhg.customerBalanceHistories;
                  }

                  return CustomerBalanceHistoryTableRows(
                    customerBalanceHistories: customerBalanceHistories,
                    type: cbhg.movementType,
                  );
                },
                error: (error, stackTrace) => errorMethod(error),
                loading: () => loadWidget,
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
