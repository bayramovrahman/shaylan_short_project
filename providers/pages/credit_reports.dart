import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';
import 'package:shaylan_agent/notifiers/pages/credit_reports.dart';

var visitPaymentInvoiceProvider = StateNotifierProvider<
    VisitPaymentInvoiceNotifier, List<VisitPaymentInvoice>>(
  (ref) => VisitPaymentInvoiceNotifier(),
);
