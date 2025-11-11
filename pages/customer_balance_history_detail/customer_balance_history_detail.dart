import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/pages/customer_balance_history_detail/parts/result_customer_balance_history_details.dart';

class CustomerBalanceHistoryDetailPage extends StatelessWidget {
  const CustomerBalanceHistoryDetailPage({super.key, required this.docID, required this.type});

  final String type;
  final int docID;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    String tableName = 'customers_invoice_details';
    String titleText = lang.invoiceHistory;

    if (type == lang.invoice) {
      tableName = 'customers_invoice_details';
      titleText = lang.invoiceHistory;
    } else if (type == lang.returns) {
      tableName = 'customers_return_details';
      titleText = lang.returnHistory;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          titleText,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.monserratBold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            IconlyLight.arrow_left_2,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ResultCustomerBalanceHistoryDetails(
        docID: docID, 
        tableName: tableName,
      ),
    );
  }
}
