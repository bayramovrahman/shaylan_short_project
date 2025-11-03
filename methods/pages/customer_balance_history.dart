import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/pages/customer_balance_history_detail/customer_balance_history_detail.dart';
import 'package:shaylan_agent/pages/customer_balance_payment_history_detail/customer_balance_payment_history_detail.dart';

GestureDetector customerBalanceHistoryTableRowMethod(
  String text,
  BuildContext context,
  int docID,
  int docNum,
  String type,
) {
  return GestureDetector(
    onTap: () {
      if (type == AppLocalizations.of(context)!.payment) {
        navigatorPushMethod(
          context,
          CustomerBalancePaymentHistoryDetailPage(docNum: docNum),
          false,
        );
        return;
      }
      navigatorPushMethod(
        context,
        CustomerBalanceHistoryDetailPage(docID: docID, type: type),
        false,
      );
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          fontFamily: AppFonts.secondaryFont,
        ),
      ),
    ),
  );
}
