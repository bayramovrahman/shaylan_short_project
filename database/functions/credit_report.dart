import 'package:shaylan_agent/database/config.dart';
import 'package:shaylan_agent/models/credit_report.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<int> removeAllCreditReport() async {
  if (db.isOpen) {
    int rowCount = await db.delete('creditReports');
    return rowCount;
  } else {
    return -1;
  }
}

Future<void> createCreditReport(
    Batch dbBatch, CreditReport creditReport) async {
  if (db.isOpen) {
    dbBatch.insert(
      'creditReports',
      creditReport.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
