import 'package:flutter/material.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/models/root_model.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/providers/internet.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:shaylan_agent/services/api/root.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rootApiProvider = Provider<RootApiService>((ref) => RootApiService());

var fetchRootsProvider =
    FutureProvider.autoDispose.family<ResultRoot, BuildContext>(
  (ref, arg) async {
    ResultRoot result = ResultRoot.defaultResult();
    List<RootModel> roots = [];
    bool hasInternet = await ref.read(checkInternetConnProvider(arg).future);
    if (hasInternet) {
      User user = await getUser();
      String token = await ref.read(tokenProvider);

      try {
        if (arg.mounted) {
          roots = await ref.read(rootApiProvider).fetchRoots(
                user.empId.toString(),
                token,
                arg,
              );
        }

        result = ResultRoot(error: '', roots: roots);
      } catch (e) {
        result = ResultRoot(error: e.toString());
      }
    }

    return result;
  },
);
