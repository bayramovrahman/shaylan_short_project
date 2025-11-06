
import 'package:flutter/foundation.dart';
import 'package:shaylan_agent/database/config.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/models/daily_visit_report.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> createVisitPaymentInvoice(
    VisitPaymentInvoice visitPaymentInvoice) async {
  if (db.isOpen) {
    await db.insert(
      'visit_payment_invoices',
      visitPaymentInvoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<List<VisitPaymentInvoice>> getVisitPaymentInvoicesByDocEntry(
  num docEntry,
) async {
  if (db.isOpen) {

    // added filter VisitPaymentStatus.error
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
        SELECT vpi.* FROM visit_payment_invoices vpi 
        INNER JOIN visit_payments vp ON vp.id = vpi.invPayId 
        WHERE vpi.docEntry = $docEntry 
        AND vp.status != "${VisitPaymentStatus.accept}" AND vp.status != "${VisitPaymentStatus.removed}" 
        AND vp.status != "${VisitPaymentStatus.error}"
        
      ''',
    );

    return List.generate(maps.length, (i) {
      return VisitPaymentInvoice.fromJson(maps[i]);
    });
  }
  return [];
}

Future<num> getSumVisitPaymentInvoicesByCardCode(String cardCode) async {
  if (db.isOpen) {
    num sumInvoices = 0;

    final List<Map<String, dynamic>> visitPaymentSums = await db.rawQuery(
      '''
          SELECT SUM(paySum) as jemi FROM visit_payments 
          WHERE status != "${VisitPaymentStatus.accept}" AND status != "${VisitPaymentStatus.removed}" 
          AND status != "${VisitPaymentStatus.error}" 
          AND cardCode = "$cardCode"
      ''',
    );


    if (visitPaymentSums.isNotEmpty) {
      for (var visitPaymentSum in visitPaymentSums) {
        if (visitPaymentSum['jemi'] != null) {
          sumInvoices += visitPaymentSum['jemi'] as num;
        }
      }
    }

    return sumInvoices;
  }
  return 0;
}

Future<List<CustomerBalanceHistory>> getVisitPaymentInvoicesByCardCode(
    String cardCode) async {
  if (db.isOpen) {
    List<CustomerBalanceHistory> cbhs = [];

    List<Map<String, dynamic>> resultVisitPaymentInvoices = await db.rawQuery(
      '''
        SELECT vpi.sumApplied AS sumApplied, v.startTime AS startTime FROM visit_payment_invoices vpi 
        INNER JOIN visit_payments vp ON vp.id = vpi.invPayId 
        INNER JOIN visits v ON v.id = vp.visitId 
        WHERE vp.cardCode = "$cardCode" 
        AND vp.status != "${VisitPaymentStatus.accept}" AND vp.status != "${VisitPaymentStatus.removed}" AND vp.status != "${VisitPaymentStatus.error}"
      ''',
    );

    if (resultVisitPaymentInvoices.isNotEmpty) {
      for (var resultVisitPaymentInvoice in resultVisitPaymentInvoices) {
        cbhs.add(CustomerBalanceHistory(
          cardCode: cardCode,
          uRouteID: '',
          movementType: 'Invoice',
          docId: 0,
          documentDate: resultVisitPaymentInvoice['startTime'],
          documentNumber: 0,
          totalAmount: resultVisitPaymentInvoice['sumApplied'],
          paidAmount: resultVisitPaymentInvoice['sumApplied'],
          balanceDue: 0,
          comments: '',
          paymentType: '',
          agent: '',
        ));
      }
    }
    return cbhs;
  }
  return [];
}

Future<List<DailyVisitReportModel>> getDailyInvoices(
    String startDate, String endDate) async {
  if (db.isOpen) {
    List<DailyVisitReportModel> dailyReports = [];

    List<Map<String, dynamic>> resultVisits = await db.query(
      'visits',
      columns: ['id'],
      where: 'DATE(endTime) BETWEEN DATE(?) AND DATE(?)',
      whereArgs: [startDate, endDate],
    );

    if (resultVisits.isNotEmpty) {
      for (var visit in resultVisits) {
        List<Map<String, dynamic>> resultPayments = await db.rawQuery(
          '''
              SELECT id,status,paymentType FROM visit_payments WHERE visitId = ${visit['id'] as int} 
          ''',
        );

        if (resultPayments.isNotEmpty) {
          for (var payment in resultPayments) {
            List<Map<String, dynamic>> resultInvoices = await db.rawQuery(
              '''
                SELECT COUNT(sumApplied) AS count , SUM(sumApplied) AS sum FROM visit_payment_invoices 
                WHERE invPayId = ${payment['id'] as int}
              ''',
            );

            debugPrint(  ' the applied sum --- ---- ${resultInvoices.first['sum']}');

            dailyReports.add(
              DailyVisitReportModel(
                count: resultInvoices.first['count'],
                sum: resultInvoices.first['sum'],
                status: payment['status'],
                paymentType: payment['paymentType'],
              ),
            );
          }
        }
      }
    }

    return dailyReports;
  }
  return [];
}

Future<int> removeVisitPaymentInvoicesByInvPayId(int invPayId) async {
  if (db.isOpen) {
    int result = await db.delete(
      'visit_payment_invoices',
      where: 'invPayId = ?',
      whereArgs: [invPayId],
    );
    return result;
  }
  return 0;
}
