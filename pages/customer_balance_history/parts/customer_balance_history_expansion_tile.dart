import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_history_table_header.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/customer_balance_history_table_rows.dart';

class CustomerBalanceHistoryExpansionTile extends StatelessWidget {
  const CustomerBalanceHistoryExpansionTile({
    super.key,
    required this.customerBalanceHistoryGroup,
  });

  final CustomerBalanceHistoryGroup customerBalanceHistoryGroup;

  @override
  Widget build(BuildContext context) {
    return customerBalanceHistoryGroup.customerBalanceHistories.isNotEmpty
        ? ExpansionTile(
            iconColor: Colors.black,
            title: Text(
              customerBalanceHistoryGroup.movementType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.monserratBold,
              ),
            ),
            children: [
              const CustomerBalanceHistoryTableHeader(),
              CustomerBalanceHistoryTableRows(
                customerBalanceHistories:
                    customerBalanceHistoryGroup.customerBalanceHistories,
                type: customerBalanceHistoryGroup.movementType,
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
