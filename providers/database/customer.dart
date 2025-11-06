import 'package:shaylan_agent/models/customer.dart';
import 'package:shaylan_agent/models/customer_credit_report.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';
import 'package:shaylan_agent/services/database/customer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerDBProvider =
    Provider<CustomerDBService>((ref) => CustomerDBService());

final getCustomersProvider =
    FutureProvider.autoDispose.family<ResultCustomer, String>(
  (ref, arg) async {
    ResultCustomer result = ResultCustomer.defaultResult();
    try {
      String search = await ref.watch(searchCustomerProvider);
      String district = await ref.watch(districtFilterProvider);

      List<Customer> customers = await ref
          .read(customerDBProvider)
          .getCustomers(search, arg, district);
      result = ResultCustomer(customers: customers, error: '');
    } catch (e) {
      result = ResultCustomer(error: e.toString());
    }
    return result;
  },
);

final getCustomersWithCreditReportProvider =
    FutureProvider.autoDispose.family<ResultCustomer, String>(
  (ref, arg) async {
    ResultCustomer result = ResultCustomer.defaultResult();
    try {
      String search = await ref.watch(searchCustomerProvider);
      String district = await ref.watch(districtFilterProvider);
      String sortBalance = await ref.watch(sortBalanceProvider);
      String expiredDay = await ref.watch(sortExpiredDayProvider);

      List<CustomerCreditReport> ccrs = await ref
          .read(customerDBProvider)
          .getCustomersWithCreditReport(
              search, arg, district, sortBalance, expiredDay);
      result = ResultCustomer(ccrs: ccrs, error: '');
    } catch (e) {
      result = ResultCustomer(error: e.toString());
    }
    return result;
  },
);
