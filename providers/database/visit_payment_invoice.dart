import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/visit_payment.dart';
import 'package:shaylan_agent/database/functions/visit_payment_invoice.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/models/visit_payment_invoice.dart';

final getVisitPaymentInvoicesByDocEntryProvider =
    FutureProvider.autoDispose.family<List<VisitPaymentInvoice>, num>(
  (ref, arg) async => await getVisitPaymentInvoicesByDocEntry(arg),
);

final getSumVisitPaymentInvoicesByCardCodeProvider =
    FutureProvider.autoDispose.family<num, String>(
  (ref, arg) async => await getSumVisitPaymentInvoicesByCardCode(arg),
);

final getVisitPaymentsByCardCodeProvider =
    FutureProvider.autoDispose.family<List<CustomerBalanceHistory>, String>(
  (ref, arg) async => await getVisitPaymentsByCardCode(arg),
);

final getVisitPaymentInvoicesByCardCodeProvider =
    FutureProvider.autoDispose.family<List<CustomerBalanceHistory>, String>(
  (ref, arg) async => await getVisitPaymentInvoicesByCardCode(arg),
);

final getVisitPaymentsByVisitIDProvider =
    FutureProvider.autoDispose.family<List<VisitPayment>, int>(
  (ref, arg) async => await getVisitPaymentsByVisitID(arg),
);

final getSumVisitPaymentInvoicesByCardCodeCreateDraftProvider =
    FutureProvider.autoDispose.family<num, String>(
  (ref, arg) async => await getSumVisitPaymentInvoicesByCardCodeAndStatus(
    arg,
    VisitPaymentStatus.createDraft,
  ),
);

final getSumVisitPaymentInvoicesByCardCodeDontSendProvider =
    FutureProvider.autoDispose.family<num, String>(
  (ref, arg) async => await getSumVisitPaymentInvoicesByCardCodeAndStatus(
    arg,
    VisitPaymentStatus.dontSent,
  ),
);

