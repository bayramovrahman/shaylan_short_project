import 'package:shaylan_agent/models/credit_report_line.dart';
import 'package:shaylan_agent/services/database/credit_report_line.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final creditReportLineDBProvider =
    Provider<CreditReportLineDBService>((ref) => CreditReportLineDBService());

final getCreditReportLinesByCardCodeProvider =
    FutureProvider.autoDispose.family<List<CreditReportLineGroup>, String>(
  (ref, arg) =>
      ref.read(creditReportLineDBProvider).getCreditReportLinesByCardCode(arg),
);

final getDistrictsByRootProvider =
    FutureProvider.autoDispose.family<List<String>, String>(
  (ref, arg) => ref.read(creditReportLineDBProvider).getDistrictsByRoot(arg),
);
