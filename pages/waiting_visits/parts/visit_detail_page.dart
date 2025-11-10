import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/app/app_colors.dart';
import 'package:shaylan_agent/database/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/providers/database/visit_payment_invoice.dart';

class VisitDetailPage extends ConsumerStatefulWidget {
  const VisitDetailPage({super.key, required this.visit});

  final VisitModel visit;

  @override
  ConsumerState<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends ConsumerState<VisitDetailPage> {
  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    final visitPaymentsAsync = ref.watch(
      getVisitPaymentsByVisitIDProvider(widget.visit.id!),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          lang.visitDeatils,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: visitPaymentsAsync.when(
        data: (visitPayments) {
          final totalAmount = _calculateTotal(visitPayments);

          return Column(
            children: [
              Expanded(
                child: visitPayments.isEmpty
                    ? _buildEmptyState(lang)
                    : _buildPaymentList(visitPayments, lang),
              ),
              _buildTotalCard(totalAmount, lang),
            ],
          );
        },
        error: (error, stackTrace) => _buildErrorState(error, context),
        loading: () => _buildLoadingState(context),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations lang) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 80.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.payment_outlined,
                    size: 56.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  lang.noPaymentMade,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontFamily: AppFonts.monserratBold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList(
      List<VisitPayment> visitPayments, AppLocalizations lang) {
    return Expanded(
      child: ListView.builder(
        padding:
            EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w, top: 8.h),
        itemCount: visitPayments.length,
        itemBuilder: (context, index) {
          return _buildPaymentCard(visitPayments[index], index + 1, lang);
        },
      ),
    );
  }

  Widget _buildPaymentCard(
      VisitPayment payment, int index, AppLocalizations lang) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          childrenPadding: EdgeInsets.all(0),
          leading: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              gradient: _getPaymentTypeGradient(payment.paymentType),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "$index",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.monserratBold,
                ),
              ),
            ),
          ),
          title: FutureBuilder<String>(
            future: _buildPaymentTitle(payment),
            builder: (context, snapshot) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      snapshot.data ?? lang.invoice,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.monserratBold,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              );
            },
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Row(
              children: [
                Icon(
                  _getPaymentTypeIcon(payment.paymentType),
                  size: 14.sp,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 4.w),
                Text(
                  _getPaymentTypeText(payment.paymentType),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    fontFamily: AppFonts.monserratBold,
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.secondaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              '${payment.paySum.toStringAsFixed(2)}\nTMT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.monserratBold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCard(double totalAmount, AppLocalizations lang) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${lang.total}:",
            style: TextStyle(
              fontSize: 18.sp,
              fontFamily: AppFonts.monserratBold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            '${totalAmount.toStringAsFixed(2)} TMT',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.monserratBold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 56.sp,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Error Loading Payments',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.monserratBold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                fontFamily: AppFonts.monserratBold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => ref.invalidate(
                  getVisitPaymentsByVisitIDProvider(widget.visit.id!)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.monserratBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            height: 80.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Loading Payments...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
              fontFamily: AppFonts.monserratBold,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getPaymentTypeGradient(String paymentType) {
    switch (paymentType.toLowerCase()) {
      case 'cash':
        return LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor
          ],
        );
      case 'credit_cards':
        return LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor
          ],
        );
      case 'bank':
        return LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor
          ],
        );
      default:
        return LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
        );
    }
  }

  IconData _getPaymentTypeIcon(String paymentType) {
    switch (paymentType.toLowerCase()) {
      case 'cash':
        return Icons.money_outlined;
      case 'credit_cards':
        return Icons.credit_card_outlined;
      case 'bank':
        return Icons.account_balance_outlined;
      default:
        return Icons.payment_outlined;
    }
  }

  Future<String> _buildPaymentTitle(VisitPayment payment) async {
    var lang = AppLocalizations.of(context)!;
    final invoices = payment.invoices;
    if (invoices != null && invoices.isNotEmpty) {
      final docEntries = invoices
          .map((invoice) => invoice.docEntry)
          .whereType<num>()
          .where((docEntry) => docEntry != 0)
          .toSet()
          .toList();

      if (docEntries.isNotEmpty) {
        final invoiceNumbers =
            await _getInvoiceNumbersFromDocEntries(docEntries);

        if (invoiceNumbers.isNotEmpty) {
          return '№${invoiceNumbers.join(', ')}';
        }
      }
    }

    final paymentId = payment.id;
    if (paymentId != null) {
      return '№$paymentId';
    }

    return lang.invoice;
  }

  Future<List<String>> _getInvoiceNumbersFromDocEntries(
      List<num> docEntries) async {
    if (!db.isOpen) return [];

    try {
      final docEntriesString = docEntries.map((e) => e.toString()).join(',');
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT DISTINCT docNum FROM creditReportLines WHERE docEntryInv IN ($docEntriesString) ORDER BY docNum',
      );

      return result
          .map((row) => row['docNum']?.toString() ?? '')
          .where((invoiceNo) => invoiceNo.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error fetching invoice numbers: $e');
      return [];
    }
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

  double _calculateTotal(List<VisitPayment> payments) {
    return payments.fold(0, (sum, payment) => sum + payment.paySum);
  }
}
