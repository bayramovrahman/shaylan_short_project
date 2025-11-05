import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:shaylan_agent/app/app_colors.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/constants/asset_path.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/pages/customer_balance_history/customer_balance_history.dart';

class NewCreditReportsPage extends StatefulWidget {
  const NewCreditReportsPage({
    super.key,
    required this.visitID,
    required this.cardCode,
  });

  final int visitID;
  final String cardCode;

  @override
  State<NewCreditReportsPage> createState() => _NewCreditReportsPageState();
}

class _NewCreditReportsPageState extends State<NewCreditReportsPage>
    with SingleTickerProviderStateMixin {
  // Just empty column

  late AnimationController _animationController;
  late Animation<double> _animation;

  List<Invoice> invoices = [
    Invoice(
      invoiceNumber: '№7816511',
      amount: 1250.00,
      date: DateTime(2025, 11, 1),
      isPaid: true,
    ),
    Invoice(
      invoiceNumber: '№8724565',
      amount: 3400.50,
      date: DateTime(2025, 11, 2),
      isPaid: true,
    ),
    Invoice(
      invoiceNumber: '№3565455',
      amount: 890.75,
      date: DateTime(2025, 11, 3),
      isPaid: true,
    ),
    Invoice(
      invoiceNumber: '№4365346',
      amount: 2150.00,
      date: DateTime(2025, 11, 4),
      isPaid: true,
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
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
      body: Column(
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
                      '${_calculateTotal().toStringAsFixed(2)} TMT',
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
                  '${invoices.length} ${lang.invoice}',
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
            child: invoices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80.sp,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Hiç hili töleg girizilmedi',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFonts.monserratBold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return _buildDismissibleInvoiceCard(invoice, index);
                    },
                  ),
          ),

          // Aşaky düwmeler
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
      ),
    );
  }

  Widget _buildDismissibleInvoiceCard(Invoice invoice, int index) {
    return Dismissible(
      key: Key(invoice.invoiceNumber),
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[400]!, Colors.red[600]!],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        // Onay dialogu göster
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Faturany pozmak'),
              content: Text(
                '${invoice.invoiceNumber} belgili faturany pozmak isleýärsiňizmi?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Ýok',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Hawa, Poz',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        setState(() {
          invoices.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${invoice.invoiceNumber} pozuldy'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Yzyna al',
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  invoices.insert(index, invoice);
                });
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Nyşan
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

                  // Maglumatlar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice.invoiceNumber,
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
                              _formatDate(invoice.date),
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

                  // Möçber we ýagdaý
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${invoice.amount.toStringAsFixed(2)} TMT',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.monserratBold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Pereçesleniýa',
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

  double _calculateTotal() {
    return invoices.fold(0, (sum, invoice) => sum + invoice.amount);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

// Invoice model synpy
class Invoice {
  final String invoiceNumber;
  final double amount;
  final DateTime date;
  final bool isPaid;

  Invoice({
    required this.invoiceNumber,
    required this.amount,
    required this.date,
    required this.isPaid,
  });
}
