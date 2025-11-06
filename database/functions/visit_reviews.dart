import 'package:shaylan_agent/database/config.dart';
import 'package:shaylan_agent/models/visit_review.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createVisitReview(VisitReview visitReview) async {
  if (db.isOpen) {
    await db.insert(
      'visit_reviews',
      visitReview.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<List<VisitReview>> getVisitReviewsByVisitID(int visitID) async {
  if (db.isOpen) {
    List<Map<String, dynamic>> resultDB = await db
        .rawQuery('''SELECT * FROM visit_reviews WHERE visitId = $visitID''');

    if (resultDB.isNotEmpty) {
      return resultDB.map((json) => VisitReview.fromJson(json)).toList();
    }

    return [];
  }
  return [];
}
