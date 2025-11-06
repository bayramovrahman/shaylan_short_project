import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var checkInternetConnProvider =
    FutureProvider.autoDispose.family<bool, BuildContext>((ref, arg) async {
  return await checkIntWithContextConn(arg);
});
