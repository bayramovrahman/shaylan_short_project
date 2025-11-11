import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_main_details.dart';
import 'package:shaylan_agent/pages/credit_report_detail/parts/credit_report_detail_products.dart';

class CreditReportDetailPage extends StatelessWidget {
  const CreditReportDetailPage({super.key, required this.creditReportLine});

  final CreditReportLine creditReportLine;

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
          lang.creditReport,
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
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                lang.tradingAgent,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.monserratBold,
                ),
              ),
            ),
            CreditReportMainDetails(creditReportLine: creditReportLine),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                lang.products,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.monserratBold,
                ),
              ),
            ),
            CreditReportDetailProducts(creditReportLine: creditReportLine),
          ],
        ),
      ),
    );
  }
}
