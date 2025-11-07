import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:shaylan_agent/providers/local_storadge.dart';
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
    
    // Get document entry
    num docEntry = widget.creditReportLine.docEntryInv != 0
        ? widget.creditReportLine.docEntryInv
        : widget.creditReportLine.docEntryRin;
    
    // Watch payment invoices for this specific invoice
    final paymentInvoicesAsync = ref.watch(
      getVisitPaymentInvoicesByDocEntryProvider(docEntry),
    );
    
    return paymentInvoicesAsync.when(
      data: (paymentInvoices) {
        // Calculate total paid amount for this invoice
        num totalPaid = 0;
        if (paymentInvoices.isNotEmpty) {
          for (var invoice in paymentInvoices) {
            totalPaid += invoice.sumApplied;
          }
        }
        
        // Calculate remaining balance
        num remainingBalance = widget.creditReportLine.balance - totalPaid;
        
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
                    
                    // Show paid amount if exists
                    if (totalPaid > 0) ...[
                      _buildInfoRow(
                        icon: Icons.check_circle,
                        label: 'Alynan Töleg',
                        value: '${totalPaid.toStringAsFixed(2)} TMT',
                        isHighlighted: true,
                        highlightColor: Colors.green[300],
                      ),
                      SizedBox(height: 10.h),
                    ],
                    
                    _buildInfoRow(
                      icon: IconlyBold.wallet,
                      label: lang.remainder,
                      value: '${remainingBalance.toStringAsFixed(2)} TMT',
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
                        onPressed: remainingBalance > 0 
                            ? () => _showPaymentDialog(context)
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payment,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              remainingBalance > 0 ? lang.payment : 'Doly Tölendi',
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
      },
      loading: () => _buildLoadingCard(),
      error: (error, stack) => _buildErrorCard(error),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16.r),
      ),
      height: 200.h,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorCard(Object error) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Text('Ýalňyşlyk: $error'),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
    Color? highlightColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isHighlighted 
              ? (highlightColor ?? Colors.yellow[500]) 
              : Colors.white70,
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
            color: isHighlighted 
                ? (highlightColor ?? Colors.yellow[400]) 
                : Colors.white,
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
  // Just empty column

  final TextEditingController amountController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController checkNumberController = TextEditingController();

  String? selectedPaymentType;
  Terminal? selectedTerminal;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectTerminalFromPreferences();
    });
  }

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
      ref.invalidate(getVisitPaymentInvoicesByDocEntryProvider(docEntry));

      if (context.mounted) {
        Navigator.of(context).pop();
        AlertUtils.showSnackBarSuccess(
          context: context,
          message: 'Töleg üstünlikli girizildi!',
          second: 3,
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Faktura №${widget.creditReportLine.docNum}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.clear_circled, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lang.remainder}: ${widget.creditReportLine.balance.toStringAsFixed(2)} TMT',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      lang.paymentOption,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    DropdownButtonFormField<String>(
                      value: selectedPaymentType,
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                      hint: const Text('Töleg görnüşini saýlaň'),
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
                          if (value != VisitPaymentType.terminal) {
                            selectedTerminal = null;
                          }
                        });
                        if (value == VisitPaymentType.terminal) {
                          _selectTerminalFromPreferences();
                        }
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Terminal Selection
                    if (selectedPaymentType == VisitPaymentType.terminal) ...[
                      Text(
                        'Terminal',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.monserratBold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      terminalsAsync.when(
                        data: (terminals) {
                          return InkWell(
                            onTap: () => _showTerminalBottomSheet(context, terminals),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: selectedTerminal != null && selectedTerminal!.assetSerNo.isNotEmpty
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${selectedTerminal!.itemName} (${selectedTerminal!.itemCode})',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: AppFonts.monserratBold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                'Seriýa: ${selectedTerminal!.assetSerNo}',
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey[600],
                                                  fontFamily: AppFonts.monserratBold,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            'Terminal saýlaň',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey[600],
                                              fontFamily: AppFonts.monserratBold,
                                            ),
                                          ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text('Ýalňyşlyk: $error'),
                      ),
                      SizedBox(height: 12.h),

                      // Check Number Field
                      Text(
                        '${lang.checkNumber} *',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.monserratBold,
                        ),
                      ),
                      SizedBox(height: 2.h),
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
                      SizedBox(height: 12.h),
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
                    SizedBox(height: 2.h),
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
                    SizedBox(height: 12.h),

                    // Comment Field
                    Text(
                      lang.comment,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                    SizedBox(height: 2.h),
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
            ),

            // Actions
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      lang.cancel,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
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
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            lang.payment,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.monserratBold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTerminalBottomSheet(BuildContext context, List<Terminal> terminals) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terminal Saýlaň',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(CupertinoIcons.clear_circled, size: 24.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: terminals.length,
                  itemBuilder: (context, index) {
                    final terminal = terminals[index];
                    final isSelected = selectedTerminal?.assetSerNo == terminal.assetSerNo;
                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      leading: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).primaryColor 
                              : Colors.green[100],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.payment,
                          color: isSelected ? Colors.white : Colors.green[600],
                          size: 24.sp,
                        ),
                      ),
                      title: Text(
                        '${terminal.itemName} (${terminal.itemCode})',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.monserratBold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${terminal.assetGroup} ${terminal.assetSerNo}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[700],
                              fontFamily: AppFonts.monserratBold,
                            ),
                          ),
                        ],
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                              size: 24.sp,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          selectedTerminal = terminal;
                        });
                        // Save to provider for future use
                        ref.read(selectedTerminalProvider.notifier).update(terminal.assetSerNo);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTerminalFromPreferences() async {
    final savedTerminalSerNo = ref.read(selectedTerminalProvider);
    if (savedTerminalSerNo.isEmpty) {
      return;
    }

    try {
      final terminals = await ref.read(getTerminalsProvider.future);
      final savedTerminal = terminals.firstWhere(
        (t) => t.assetSerNo == savedTerminalSerNo,
        orElse: () => Terminal.defaultTerminal(),
      );

      if (savedTerminal.assetSerNo.isNotEmpty && mounted) {
        setState(() {
          selectedTerminal = savedTerminal;
        });
      }
    } catch (_) {
      // Ignore errors when terminals are not yet available
    }
  }
}