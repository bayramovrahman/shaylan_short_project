import 'package:shaylan_agent/database/config.dart';
import 'package:shaylan_agent/models/terminal.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<int> removeAllTerminal() async {
  if (db.isOpen) {
    int rowCount = await db.delete('terminals');
    return rowCount;
  } else {
    return -1;
  }
}

void createTerminal(Batch dbBatch, Terminal terminal) {
  if (db.isOpen) {
    dbBatch.insert(
      'terminals',
      terminal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<String> getTerminalBySerNo(String assetSerNo) async {
  if (db.isOpen) {
    List<Map<String, dynamic>> resultDB = await db.rawQuery(
      '''SELECT account FROM terminals WHERE assetSerNo = "$assetSerNo"''',
    );

    if (resultDB.isNotEmpty) {
      return resultDB.first['account'] as String;
    }
    return '';
  }
  return '';
}
