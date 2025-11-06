import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/customer_balance_history.dart';
import 'package:shaylan_agent/models/customer_balance_history_detail.dart';
import 'package:shaylan_agent/services/database/customer_balance_history.dart';

final customerBalanceHistoryDBProvider =
    Provider<CustomerBalanceHistoryDBService>(
        (ref) => CustomerBalanceHistoryDBService());

final getAllCustomerBalanceHistoriesProvider =
    FutureProvider.autoDispose.family<ResultCustomerBalanceHistory, String>(
  (ref, arg) async {
    ResultCustomerBalanceHistory result =
        ResultCustomerBalanceHistory.defaultResult();
    try {
      List<CustomerBalanceHistory> customers = await ref
          .read(customerBalanceHistoryDBProvider)
          .getAllCustomerBalanceHistories(arg);
      result = ResultCustomerBalanceHistory(
          customerBalanceHistories: customers, error: '');
    } catch (e) {
      result = ResultCustomerBalanceHistory(error: e.toString());
    }
    return result;
  },
);

final getCustomerBalanceHistoryDetailsByDocIdProvider = FutureProvider
    .autoDispose
    .family<ResultCustomerBalanceHistory, CustomerBalanceHistoryParams>(
  (ref, arg) async {
    ResultCustomerBalanceHistory result =
        ResultCustomerBalanceHistory.defaultResult();
    try {
      List<CustomerBalanceHistoryDetail> customers = await ref
          .read(customerBalanceHistoryDBProvider)
          .getCustomerBalanceHistoryDetailsByDocId(arg.docId!, arg.tableName!);

      result = ResultCustomerBalanceHistory(
          customerBalanceHistoryDetails: customers, error: '');
    } catch (e) {
      result = ResultCustomerBalanceHistory(error: e.toString());
    }
    return result;
  },
);

final getCustomerBalancePaymentHistoryDetailsByDocIdProvider =
    FutureProvider.autoDispose.family<ResultCustomerBalanceHistory, int>(
  (ref, arg) async {
    ResultCustomerBalanceHistory result =
        ResultCustomerBalanceHistory.defaultResult();
    try {
      List<CustomerBalancePaymentHistoryDetail> customers = await ref
          .read(customerBalanceHistoryDBProvider)
          .getCustomerBalancePaymentHistoryDetailsByDocId(arg);

      result = ResultCustomerBalanceHistory(
          customerBalancePaymentHistoryDetails: customers, error: '');
    } catch (e) {
      result = ResultCustomerBalanceHistory(error: e.toString());
    }
    return result;
  },
);
