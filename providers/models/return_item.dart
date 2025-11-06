import 'package:shaylan_agent/models/return_item_count.dart';
import 'package:shaylan_agent/providers/internet.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:shaylan_agent/services/api/return_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final returnItemApiProvider =
    Provider<ReturnItemApiService>((ref) => ReturnItemApiService());

var fetchReturnItemCountProvider =
    FutureProvider.autoDispose.family<ResultReturnItemCount, ReturnItemParams>(
  (ref, arg) async {
    ResultReturnItemCount result = ResultReturnItemCount.defaultResult();
    List<ReturnItemCount> returnItemCounts = [];
    bool hasInternet =
        await ref.read(checkInternetConnProvider(arg.context).future);
    if (hasInternet) {
      String token = await ref.read(tokenProvider);

      try {
        if (arg.context.mounted) {
          returnItemCounts =
              await ref.read(returnItemApiProvider).fetchReturnItemCount(
                    arg.clientCode!,
                    arg.itemCode!,
                    token,
                    arg.context,
                  );
        }

        result = ResultReturnItemCount(
            error: '', returnItemCounts: returnItemCounts);
      } catch (e) {
        result = ResultReturnItemCount(error: e.toString());
      }
    }

    return result;
  },
);

var sendReturnItem =
    FutureProvider.autoDispose.family<ResultReturnItemCount, ReturnItemParams>(
  (ref, arg) async {
    ResultReturnItemCount result = ResultReturnItemCount.defaultResult();
    bool isSend = false;
    bool hasInternet =
        await ref.read(checkInternetConnProvider(arg.context).future);

    if (hasInternet) {
      String token = await ref.read(tokenProvider);

      try {
        if (arg.context.mounted) {
          isSend = await ref
              .read(returnItemApiProvider)
              .sendReturnItem(arg.returnItemBody!, token, arg.context);
        }

        result = ResultReturnItemCount(error: '', isSend: isSend);
      } catch (e) {
        result = ResultReturnItemCount(error: e.toString());
      }
    }

    return result;
  },
);
