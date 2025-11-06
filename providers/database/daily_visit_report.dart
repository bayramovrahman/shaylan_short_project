import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/visit_payment_invoice.dart';
import 'package:shaylan_agent/models/daily_visit_report.dart';

final getDailyInvoicesProvider = FutureProvider.autoDispose
    .family<List<DailyVisitReportModel>, DailyVisitParam>(
  (ref, arg) async => await getDailyInvoices(arg.startDate, arg.endDate),
);
