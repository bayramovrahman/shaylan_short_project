import 'package:flutter/material.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/item_stock.dart';
import 'package:shaylan_agent/synchronization/synchprogres.dart';
import 'package:shaylan_agent/partial/gridview_part.dart';

class WarehouseManagerGridview extends StatefulWidget {
  const WarehouseManagerGridview({super.key});

  @override
  State<WarehouseManagerGridview> createState() =>
      _WarehouseManagerGridviewState();
}

class _WarehouseManagerGridviewState extends State<WarehouseManagerGridview> {
  // VARIABLE ------------------------------------------------------------------
  User user = User.defaultUser();

  // INIT STATE ----------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    getUser().then((value) => user = value);
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    List<String> texts = [
      lang.synchronize,
      // lang.returnedProducts,
      lang.stock,
    ];

    List<IconData> icons = [
      Icons.download,
      // Icons.cached,
      Icons.warehouse,
    ];

    func4() {
      navigatorPushMethod(
        context,
        const SynchProgress(isAfterLogin: false),
        false,
      );
    }

    // func2() {
    //   navigatorPushMethod(context, ReturnedDelivery(user: user), false);
    // }

    func5() {
      navigatorPushMethod(context, const ItemStock(), false);
    }

    List<Function()?> functions = [
      func4,
      // func2,
      func5,
    ];

    return GridviewPart(texts: texts, functions: functions, icons: icons);
  }
}
