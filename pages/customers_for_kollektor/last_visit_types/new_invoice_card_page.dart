import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/models/terminal.dart';
import 'package:shaylan_agent/methods/snackbars.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/utilities/alert_utils.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/providers/database/terminal.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:shaylan_agent/database/functions/visit_payment.dart';
import 'package:shaylan_agent/database/functions/visit_payment_invoice.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';

class NewInvoiceCard extends ConsumerStatefulWidget {
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
  ConsumerState<NewInvoiceCard> createState() => _NewInvoiceCardState();
}

class _NewInvoiceCardState extends ConsumerState<NewInvoiceCard> {
  // Just empty column
  
  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _PaymentDialog(
          creditReportLine: widget.creditReportLine,
          visitID: widget.visitID,
          cardCode: widget.cardCode,
        );
      },
    );
  }

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
          onTap: () => _showPaymentDialog(context),
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
                            '№${widget.creditReportLine.docNum}',
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
                _buildInfoRow(
                  icon: Icons.mode_standby_sharp,
                  label: lang.loanAmount,
                  value: '${widget.creditReportLine.creditSum} TMT',
                ),
                SizedBox(height: 10.h),
                _buildInfoRow(
                  icon: Icons.payment,
                  label: lang.paymentOption,
                  value: widget.creditReportLine.paymentType,
                ),
                SizedBox(height: 10.h),
                _buildInfoRow(
                  icon: Icons.access_time,
                  label: lang.expiredDay,
                  value: '${widget.creditReportLine.expired} gün',
                ),
                SizedBox(height: 10.h),
                _buildInfoRow(
                  icon: IconlyBold.wallet,
                  label: lang.remainder,
                  value: '${widget.creditReportLine.balance} TMT',
                  isHighlighted: true,
                ),
                SizedBox(height: 16.h),
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
                    onPressed: () => _showPaymentDialog(context),
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

class _PaymentDialog extends ConsumerStatefulWidget {
  const _PaymentDialog({
    required this.creditReportLine,
    required this.visitID,
    required this.cardCode,
  });

  final CreditReportLine creditReportLine;
  final int visitID;
  final String cardCode;

  @override
  ConsumerState<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<_PaymentDialog> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController checkNumberController = TextEditingController();
  
  String? selectedPaymentType;
  Terminal? selectedTerminal;
  bool isProcessing = false;

  @override
  void dispose() {
    amountController.dispose();
    commentController.dispose();
    checkNumberController.dispose();
    super.dispose();
  }

  Future<void> _processPayment(BuildContext context, AppLocalizations lang) async {
    if (selectedPaymentType == null) {
      showErrSnackBar(context, 'Töleg görnüşini saýlaň!');
      return;
    }

    if (amountController.text.isEmpty) {
      showErrSnackBar(context, 'Töleg möçberini giriziň!');
      return;
    }

    final amount = num.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      showErrSnackBar(context, 'Dogry san giriziň!');
      return;
    }

    if (amount > widget.creditReportLine.balance) {
      showErrSnackBar(context, 'Töleg möçberi galyndydan uly bolup bilmez!');
      return;
    }

    if (selectedPaymentType == VisitPaymentType.terminal) {
      if (selectedTerminal == null) {
        showErrSnackBar(context, 'Terminal saýlaň!');
        return;
      }
      if (checkNumberController.text.isEmpty) {
        showErrSnackBar(context, 'Çek nomeri giriziň!');
        return;
      }
    }

    setState(() {
      isProcessing = true;
    });

    try {
      User user = await getUser();
      
      num docEntry = widget.creditReportLine.docEntryInv != 0
          ? widget.creditReportLine.docEntryInv
          : widget.creditReportLine.docEntryRin;

      VisitPayment visitPayment = VisitPayment(
        visitId: widget.visitID,
        comment: commentController.text,
        cashAccount: selectedPaymentType == VisitPaymentType.terminal
            ? selectedTerminal!.account
            : user.account,
        paymentType: selectedPaymentType!,
        cardCode: widget.cardCode,
        status: VisitPaymentStatus.dontSent,
        paySum: amount,
        terminalNumber: selectedPaymentType == VisitPaymentType.terminal
            ? selectedTerminal!.assetSerNo
            : '',
        checkNumber: selectedPaymentType == VisitPaymentType.terminal
            ? int.parse(checkNumberController.text)
            : 0,
      );

      int visitPaymentID = await createVisitPayment(visitPayment);

      VisitPaymentInvoice visitPaymentInvoice = VisitPaymentInvoice(
        invPayId: visitPaymentID,
        docEntry: docEntry,
        sumApplied: amount,
      );

      await createVisitPaymentInvoice(visitPaymentInvoice);

      // Refresh providers
      ref.invalidate(getVisitPaymentsByVisitIDProvider(widget.visitID));
      ref.invalidate(getSumVisitPaymentInvoicesByCardCodeProvider(widget.cardCode));

      if (context.mounted) {
        Navigator.of(context).pop();
        AlertUtils.showSuccessAlert(
          context: context,
          message: 'Töleg üstünlikli girizildi!',
          lang: lang,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showErrSnackBar(context, 'Ýalňyşlyk ýüze çykdy: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    final terminalsAsync = ref.watch(getTerminalsProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        'Faktura №${widget.creditReportLine.docNum}',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          fontFamily: AppFonts.monserratBold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${lang.remainder}: ${widget.creditReportLine.balance} TMT',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: AppFonts.monserratBold,
              ),
            ),
            SizedBox(height: 20.h),
            
            // Payment Type Dropdown
            Text(
              lang.paymentOption,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.monserratBold,
              ),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              value: selectedPaymentType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
              ),
              hint: Text('Töleg görnüşini saýlaň'),
              items: [
                DropdownMenuItem(
                  value: VisitPaymentType.nagt,
                  child: Text(lang.cashPayment),
                ),
                DropdownMenuItem(
                  value: VisitPaymentType.terminal,
                  child: Text(lang.terminal),
                ),
                DropdownMenuItem(
                  value: VisitPaymentType.perecesleniya,
                  child: Text(lang.enumeration),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPaymentType = value;
                  selectedTerminal = null;
                });
              },
            ),
            SizedBox(height: 16.h),

            // Terminal Selection (only if payment type is terminal)
            if (selectedPaymentType == VisitPaymentType.terminal) ...[
              Text(
                'Terminal',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.monserratBold,
                ),
              ),
              SizedBox(height: 8.h),
              terminalsAsync.when(
                data: (terminals) {
                  return DropdownButtonFormField<Terminal>(
                    value: selectedTerminal,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                    ),
                    hint: Text('Terminal saýlaň'),
                    items: terminals.map((terminal) {
                      return DropdownMenuItem(
                        value: terminal,
                        child: Text('${terminal.itemName} ${terminal.itemCode}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTerminal = value;
                      });
                    },
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (error, stack) => Text('Ýalňyşlyk: $error'),
              ),
              SizedBox(height: 16.h),

              // Check Number Field
              Text(
                '${lang.checkNumber} *',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.monserratBold,
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: checkNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  hintText: 'Çek nomerini giriziň',
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Amount Field
            Text(
              'Töleg möçberi *',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.monserratBold,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                hintText: 'Möçberi giriziň',
                suffixText: 'TMT',
              ),
            ),
            SizedBox(height: 16.h),

            // Comment Field
            Text(
              lang.comment,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.monserratBold,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: commentController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                hintText: 'Teswir giriziň',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
          child: Text(
            lang.cancel,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: isProcessing ? null : () => _processPayment(context, lang),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: isProcessing
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  lang.payment,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}