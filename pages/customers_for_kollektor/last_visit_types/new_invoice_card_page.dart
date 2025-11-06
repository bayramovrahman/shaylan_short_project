import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/last_visit_types/new_select_payment_type_page.dart';

class NewInvoiceCard extends StatelessWidget {
  const NewInvoiceCard({
    super.key,
    required this.creditReportLine,
    required this.visitID,
    required this.cardCode,
  });

  final CreditReportLine creditReportLine;
  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[600]!,
            Colors.blue[800]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            navigatorPushMethod(
              context,
              NewSelectPaymentTypePage(
                creditReportLine: creditReportLine,
                visitID: visitID,
                cardCode: cardCode,
              ),
              false,
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.receipt,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Faktura Nomeri",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppFonts.monserratBold,
                            ),
                          ),
                          Text(
                            '№${creditReportLine.docNum}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.monserratBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Invoice details
                _buildInfoRow(
                  icon: Icons.mode_standby_sharp,
                  label: lang.loanAmount,
                  value: '${creditReportLine.creditSum} TMT',
                ),
                SizedBox(height: 10.h),
                _buildInfoRow(
                  icon: Icons.payment,
                  label: lang.paymentOption,
                  value: creditReportLine.paymentType,
                ),
                SizedBox(height: 10.h),
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: lang.expiredDay,
                  value: '${creditReportLine.expired} gün',
                ),
                SizedBox(height: 10.h),
                _buildInfoRow(
                  icon: IconlyBold.wallet,
                  label: lang.remainder,
                  value: '${creditReportLine.balance} TMT',
                  isHighlighted: true,
                ),
                SizedBox(height: 16.h),

                // Payment button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue[700],
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          lang.payment,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isHighlighted ? Colors.yellow[500] : Colors.white70,
          size: 18.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              fontSize: 13.sp,
              fontFamily: AppFonts.monserratBold,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            color: isHighlighted ? Colors.yellow[400] : Colors.white,
            fontSize: isHighlighted ? 15.sp : 14.sp,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            fontFamily: AppFonts.monserratBold,
          ),
        ),
      ],
    );
  }
}