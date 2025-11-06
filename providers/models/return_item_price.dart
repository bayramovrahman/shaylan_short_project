import 'package:shaylan_agent/models/return_item_count.dart';
import 'package:shaylan_agent/providers/internet.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:shaylan_agent/services/api/return_item.dart';
import 'package:shaylan_agent/services/api/return_item_price.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/return_item_price.dart' as model;

final returnItemPriceApiProvider =
    Provider<ReturnItemPriceApiService>((ref) => ReturnItemPriceApiService());

var fetchReturnItemPrice =
    FutureProvider.autoDispose.family<ResultReturnItemCount, ReturnItemParams>(
  (ref, arg) async {
    ResultReturnItemCount result = ResultReturnItemCount.defaultResult();
    List<model.ReturnItemPrice> returnItemPrices = [];
    bool hasInternet =
        await ref.read(checkInternetConnProvider(arg.context).future);

    if (hasInternet) {
      String token = await ref.read(tokenProvider);

      try {
        if (arg.context.mounted) {
          returnItemPrices =
              await ref.read(returnItemPriceApiProvider).fetchReturnItemPrice(
                    arg.clientCode!,
                    arg.itemCode!,
                    token,
                    arg.context,
                  );
        }

        result = ResultReturnItemCount(
            error: '', returnItemPrices: returnItemPrices);
      } catch (e) {
        result = ResultReturnItemCount(error: e.toString());
      }
    }

    return result;
  },
);
