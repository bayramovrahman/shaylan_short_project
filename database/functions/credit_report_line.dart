import 'package:shaylan_agent/database/config.dart';
import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> removeAllCreditReportLine() async {
  if (db.isOpen) {
    await db.delete('creditReportLines');
  }
}

Future<void> createCreditReportLine(
    Batch dbBatch, CreditReportLine creditReportLine) async {
  if (db.isOpen) {
    dbBatch.insert(
      'creditReportLines',
      creditReportLine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<String> getCreditReportLineClientByCardCode(String cardCode) async {
  if (db.isOpen) {
    final List<Map<String, dynamic>> result = await db.query(
      'creditReportLines',
      columns: ['client'],
      where: 'cardCode = ?',
      whereArgs: [cardCode],
    );

    if (result.isNotEmpty) {
      return result.first['client'] as String;
    }
    return '';
  }
  return '';
}
