import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/pages/credit_reports/credit_reports.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/start_visit_step_two_button.dart';
import 'package:shaylan_agent/pages/customer_balance_history/parts/result_customer_balance_histories.dart';

class CustomerBalanceHistoryPage extends StatelessWidget {
  const CustomerBalanceHistoryPage({
    super.key,
    this.visitType,
    required this.cardCode,
    required this.visitID,
    required this.afterPayment,
  });

  final String cardCode;
  final int visitID;
  final bool afterPayment;
  final String? visitType;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          lang.customerBalanceHistory,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.monserratBold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => navigatorPushMethod(
              context,
              CreditReportsPage(
                cardCode: cardCode,
              ),
              false,
            ),
            icon: Icon(
              Icons.receipt_outlined,
              color: Colors.white,
            )
          ),
        ],
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
      body: ResultCustomerBalanceHistories(cardCode: cardCode),
      floatingActionButton: visitType != null 
        ? SizedBox.shrink()
        : StartVisitStepTwoButton(
        cardCode: cardCode,
        visitID: visitID,
        afterPayment: afterPayment,
      ),
    );
  }
}
