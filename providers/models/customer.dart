// import 'package:shaylan_agent/models/customer.dart';
// import 'package:shaylan_agent/providers/internet.dart';
// import 'package:shaylan_agent/providers/local_storadge.dart';
// import 'package:shaylan_agent/services/api/customer.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final customerApiProvider =
//     Provider<CustomerApiService>((ref) => CustomerApiService());

// var createCustomerProvider =
//     FutureProvider.autoDispose.family<ResultCustomer, CustomerParams>(
//   (ref, arg) async {
//     ResultCustomer result = ResultCustomer.defaultResult();
//     bool isSend = false;
//     bool hasInternet =
//         await ref.read(checkInternetConnProvider(arg.context).future);

//     if (hasInternet) {
//       String token = await ref.read(tokenProvider);

//       try {
//         if (arg.context.mounted) {
//           isSend = await ref
//               .read(customerApiProvider)
//               .createCustomer(token, arg.createCustomerObject!, arg.context);
//         }

//         result = ResultCustomer(error: '', isSend: isSend);
//       } catch (e) {
//         result = ResultCustomer(error: e.toString());
//       }
//     }

//     return result;
//   },
// );
