import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:shaylan_agent/app/app_colors.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/constants/asset_path.dart';
import 'package:shaylan_agent/database/functions/visit_payment.dart';
import 'package:shaylan_agent/database/functions/visit_payment_invoice.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/pages/customer_balance_history/customer_balance_history.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/last_visit_types/new_invoice_list_page.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';
import 'package:shaylan_agent/utilities/alert_utils.dart';

class NewCreditReportsPage extends ConsumerStatefulWidget {
  const NewCreditReportsPage({
    super.key,
    required this.visitID,
    required this.cardCode,
  });

  final int visitID;
  final String cardCode;

  @override
  ConsumerState<NewCreditReportsPage> createState() => _NewCreditReportsPageState();
}

class _NewCreditReportsPageState extends ConsumerState<NewCreditReportsPage> with SingleTickerProviderStateMixin {
  // Just empty column

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    debugPrint(
      'NewCreditReportsPage - visitID: ${widget.visitID}, cardCode: ${widget.cardCode}',
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getPaymentTypeText(String paymentType) {
    switch (paymentType.toLowerCase()) {
      case 'cash':
        return 'Nagt';
      case 'credit_cards':
        return 'Terminal';
      case 'bank':
        return 'Pereçesleniýa';
      default:
        return paymentType;
    }
  }

  Future<bool> _confirmDeletePayment(BuildContext context) async {
    var lang = AppLocalizations.of(context)!;
    return await AlertUtils.showDeletePaymentConfirmation(
      context: context,
      message: 'Bu tölegi pozmak isleýärsiňizmi?',
      lang: lang,
    );
  }

  Future<void> _deletePayment(VisitPayment payment) async {
    try {
      await removeVisitPaymentInvoicesByInvPayId(payment.id!);
      await removeVisitPaymentById(payment.id!);

      ref.invalidate(getVisitPaymentsByVisitIDProvider(widget.visitID));
      ref.invalidate(getSumVisitPaymentInvoicesByCardCodeProvider(widget.cardCode));

      await Future.delayed(Duration.zero);
      if (mounted) {
        AlertUtils.showSnackBarError(
          context: context,
          message: 'Töleg pozuldy',
          second: 3,
        );
      }
    } catch (e) {
      if (mounted) {
        AlertUtils.showSnackBarError(
          context: context,
          message: 'Ýalňyşlyk: $e',
          second: 3,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    
    final visitPaymentsAsync = ref.watch(
      getVisitPaymentsByVisitIDProvider(widget.visitID),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          lang.creditReport,
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
        actions: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value,
                child: GestureDetector(
                  onTap: () {
                    navigatorPushMethod(
                      context,
                      CustomerBalanceHistoryPage(
                        cardCode: widget.cardCode,
                        visitID: widget.visitID,
                        afterPayment: false,
                      ),
                      false,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      size: 28.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: visitPaymentsAsync.when(
        data: (visitPayments) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                child: Column(
                  children: [
                    Text(
                      'Jemi Alynan Töleg',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 45.w,
                          height: 45.h,
                          child: Lottie.asset(
                            AssetPath.moneyAnimation,
                            repeat: false,
                            fit: BoxFit.contain,
                            animate: true,
                          ),
                        ),
                        Text(
                          '${_calculateTotal(visitPayments).toStringAsFixed(2)} TMT',
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      '${visitPayments.length} ${lang.invoice}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.monserratBold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: visitPayments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 80.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Hiç hili töleg girizilmedi',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.monserratBold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: visitPayments.length,
                        itemBuilder: (context, index) {
                          final payment = visitPayments[index];
                          return _buildDismissibleInvoiceCard(
                            payment,
                            index,
                            visitPayments,
                          );
                        },
                      ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Wiziti Tamamla',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.monserratBold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            navigatorPushMethod(
                              context,
                              NewInvoiceListPage(
                                cardCode: widget.cardCode,
                                visitID: widget.visitID,
                              ),
                              false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Töleg Giriz',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.monserratBold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDismissibleInvoiceCard(
    VisitPayment payment,
    int index,
    List<VisitPayment> allPayments,
  ) {
    return Dismissible(
      key: Key('payment_${payment.id}_${DateTime.now().millisecondsSinceEpoch}'), // Unique key
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[400]!, Colors.red[600]!],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 24.w),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 32.sp),
      ),
      confirmDismiss: (direction) async {
        return await _confirmDeletePayment(context);
      },
      onDismissed: (direction) async {
        await _deletePayment(payment);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,
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
                      Icons.receipt,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Töleg №${payment.id}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              size: 14.sp,
                              color: Colors.grey[800],
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              _formatDate(DateTime.now()),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.monserratBold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${payment.paySum.toStringAsFixed(2)} TMT',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.monserratBold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          _getPaymentTypeText(payment.paymentType),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryColor,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateTotal(List<VisitPayment> payments) {
    return payments.fold(0, (sum, payment) => sum + payment.paySum);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}