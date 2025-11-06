import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/models/return_object.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/providers/internet.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:shaylan_agent/services/api/return_object.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final returnObjectApiProvider =
    Provider<ReturnObjectApiService>((ref) => ReturnObjectApiService());

var fetchReturnObjectsProvider =
    FutureProvider.autoDispose.family<ResultReturnObject, ReturnObjectParams>(
  (ref, arg) async {
    ResultReturnObject result = ResultReturnObject.defaultResult();

    List<ReturnObject> returnObjects = [];
    bool hasInternet =
        await ref.read(checkInternetConnProvider(arg.context!).future);
    if (hasInternet) {
      String token = await ref.read(tokenProvider);
      User user = await getUser();

      try {
        if (arg.context!.mounted) {
          returnObjects =
              await ref.read(returnObjectApiProvider).fetchReturnObjects(
                    user.empId.toString(),
                    user.jobTitle == UserJobTtitle.sahamcaMudir
                        ? 'manager'
                        : 'supervisor',
                    token,
                    arg.context!,
                  );
        }

        result = ResultReturnObject(error: '', returnObjects: returnObjects);
      } catch (e) {
        result = ResultReturnObject(error: e.toString());
      }
    }

    return result;
  },
);

var updateReturnObjectProvider =
    FutureProvider.autoDispose.family<ResultReturnObject, ReturnObjectParams>(
  (ref, arg) async {
    ResultReturnObject result = ResultReturnObject.defaultResult();
    bool isSend = false;
    bool hasInternet =
        await ref.read(checkInternetConnProvider(arg.context!).future);

    if (hasInternet) {
      String token = await ref.read(tokenProvider);
      try {
        if (arg.context!.mounted) {
          isSend = await ref.read(returnObjectApiProvider).updateReturnObject(
                token,
                arg.returnObject!,
                arg.context!,
              );
        }

        result = ResultReturnObject(error: '', isSend: isSend);
      } catch (e) {
        result = ResultReturnObject(error: e.toString());
      }
    }
    return result;
  },
);

var fetchReturnObjectsHistoryProvider =
    FutureProvider.autoDispose.family<ResultReturnObject, ReturnObjectParams>(
  (ref, arg) async {
    String userType = '';
    ResultReturnObject result = ResultReturnObject.defaultResult();

    List<ReturnObject> returnObjects = [];
    bool hasInternet =
        await ref.read(checkInternetConnProvider(arg.context!).future);
    if (hasInternet) {
      String token = await ref.read(tokenProvider);
      User user = await getUser();
      if (user.jobTitle == UserJobTtitle.sahamcaMudir) {
        userType = 'manager';
      } else if (user.jobTitle == UserJobTtitle.superwayzer || user.jobTitle == UserJobTtitle.kollektor ) {
        userType = 'supervisor';
      } else if (user.jobTitle == UserJobTtitle.targowy) {
        userType = 'agent';
      }

      try {
        if (arg.context!.mounted) {
          returnObjects =
              await ref.read(returnObjectApiProvider).fetchReturnObjectsHistory(
                    user.empId.toString(),
                    userType,
                    token,
                    arg.context!,
                    arg.page!,
                  );
        }

        result = ResultReturnObject(error: '', returnObjects: returnObjects);
      } catch (e) {
        result = ResultReturnObject(error: e.toString());
      }
    }
    return result;
  },
);
