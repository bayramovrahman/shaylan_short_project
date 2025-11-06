import 'package:shaylan_agent/database/config.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<int> createVisitPayment(VisitPayment visitPayment) async {
  if (db.isOpen) {
    return await db.insert(
      'visit_payments',
      visitPayment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  return 0;
}

Future<void> setStatusToVisitPayments(int visitId, String status) async {
  if (db.isOpen) {
    await db.update(
      'visit_payments',
      {'status': status},
      where: 'visitId = ?',
      whereArgs: [visitId],
    );
  }
}

Future<int> removeVisitPaymentById(int id) async {
  if (db.isOpen) {
    int result = await db.delete(
      'visit_payments',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }
  return 0;
}

Future<List<VisitPayment>> getVisitPaymentsByVisitID(int visitId) async {
  if (db.isOpen) {
    final List<Map<String, dynamic>> paymentMaps = await db.query(
      'visit_payments',
      where: 'visitId = ?',
      whereArgs: [visitId],
    );

    List<VisitPayment> visitPayments = [];
    for (var paymentMap in paymentMaps) {
      final visitPayment = VisitPayment.fromJson(paymentMap);

      final List<Map<String, dynamic>> invoiceMaps = await db.query(
        'visit_payment_invoices',
        where: 'invPayId = ?',
        whereArgs: [visitPayment.id],
      );

      final invoices = invoiceMaps
          .map((invoiceMap) => VisitPaymentInvoice.fromJson(invoiceMap))
          .toList();

      visitPayments.add(
        visitPayment.copyWith(invoices: invoices),
      );
    }

    return visitPayments;
  }
  return [];
}

Future<List<CustomerBalanceHistory>> getVisitPaymentsByCardCode(
    String cardCode) async {
  if (db.isOpen) {
    List<CustomerBalanceHistory> cbhs = [];

    List<Map<String, dynamic>> resultVisitPayments = await db.rawQuery(
      '''
        SELECT paySum,visitId FROM visit_payments WHERE cardCode = "$cardCode" 
        AND status != "${VisitPaymentStatus.accept}" AND status != "${VisitPaymentStatus.removed}"
      ''',
    );

    if (resultVisitPayments.isNotEmpty) {
      for (var resultVisitPayment in resultVisitPayments) {
        List<Map<String, dynamic>> resultVisits = await db.rawQuery(
          '''SELECT startTime FROM visits WHERE id = ${resultVisitPayment['visitId']} ''',
        );

        cbhs.add(CustomerBalanceHistory(
          cardCode: cardCode,
          uRouteID: '',
          movementType: 'Payment',
          docId: 0,
          documentDate: resultVisits.first['startTime'],
          documentNumber: 0,
          totalAmount: resultVisitPayment['paySum'],
          paidAmount: resultVisitPayment['paySum'],
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

Future<void> removeVisitPaymentsByVisitID(int visitID) async {
  if (db.isOpen) {
    List<Map<String, dynamic>> resultDB = await db
        .rawQuery('''SELECT id FROM visit_payments WHERE visitId = $visitID''');

    if (resultDB.isNotEmpty) {
      for (var visitPayment in resultDB) {
        await db.rawDelete(
          '''DELETE FROM visit_payment_invoices WHERE invPayId = ${visitPayment['id']}''',
        );
      }
    }

    await db
        .rawDelete('''DELETE FROM visit_payments WHERE visitId = $visitID''');
  }
}
