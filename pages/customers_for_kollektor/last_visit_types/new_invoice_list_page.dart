import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/providers/database/credit_report_line.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/last_visit_types/new_invoice_card_page.dart';

class NewInvoiceListPage extends ConsumerWidget {
  const NewInvoiceListPage({
    super.key,
    required this.cardCode,
    required this.visitID,
  });

  final String cardCode;
  final int visitID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    AsyncValue<List<CreditReportLineGroup>> creditReportLineGroups = ref.watch(getCreditReportLinesByCardCodeProvider(cardCode));
    AsyncValue<num> visitPayments = ref.watch(getSumVisitPaymentInvoicesByCardCodeProvider(cardCode));
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          lang.acceptingPayment,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.monserratBold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
        color: Colors.grey[200],
        child: creditReportLineGroups.when(
          data: (response) {
            if (response.isEmpty || response.first.creditReportLines.isEmpty) {
              return Center(child: Text(lang.noData));
            }
        
            num sumBalance = 0;
            for (CreditReportLineGroup crlg in response) {
              for (CreditReportLine crl in crlg.creditReportLines) {
                sumBalance += crl.balance;
              }
            }
        
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                visitPayments.when(
                  data: (visitPaymentData) {
                    return Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${lang.totalAmountRemainder} : ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.monserratBold,
                                  ),
                                ),
                                Text(
                                  "${sumBalance.toStringAsFixed(2)} ${lang.manat}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFonts.monserratBold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            if (visitPaymentData != 0) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${lang.statusNotApproved} : ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                    ),
                                  ),
                                  Text(
                                    "${visitPaymentData.toStringAsFixed(2)} ${lang.manat}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${lang.remainder} : ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                    ),
                                  ),
                                  Text(
                                    "${(sumBalance - visitPaymentData).toStringAsFixed(2)} ${lang.manat}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.monserratBold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => errorMethod(error),
                  loading: () => const SizedBox.shrink(),
                ),
        
                // Invoice List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    itemCount: response.length,
                    itemBuilder: (context, index) {
                      final group = response[index];
                      if (group.creditReportLines.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            childrenPadding: EdgeInsets.only(bottom: 8.h),
                            leading: Container(
                              width: 36.w,
                              height: 36.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.receipt_long,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                            title: Text(
                              '${lang.group} ${group.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                fontFamily: AppFonts.monserratBold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                '${group.creditReportLines.length} ${lang.quantityforItems} ${lang.invoice}'.toLowerCase(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.monserratBold,
                                ),
                              ),
                            ),
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                itemCount: group.creditReportLines.length,
                                itemBuilder: (context, invoiceIndex) {
                                  return NewInvoiceCard(
                                    creditReportLine: group.creditReportLines[invoiceIndex],
                                    visitID: visitID,
                                    cardCode: cardCode,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) => errorMethod(error),
          loading: () => loadWidget,
        ),
      ),
    );
  }
}
