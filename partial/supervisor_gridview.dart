import 'package:flutter/material.dart';
import 'package:shaylan_agent/pages/customers/customers.dart';
import 'package:shaylan_agent/pages/item_stock.dart';
import 'package:shaylan_agent/pages/searchbp.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/synchronization/synchprogres.dart';
import 'package:shaylan_agent/partial/gridview_part.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/return_objects/return_objects.dart';

class SupervisorGridview extends StatelessWidget {
  const SupervisorGridview({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    List<IconData?> icons = [
      Icons.download,
      Icons.edit_document,
      Icons.history,
      Icons.warehouse,
      Icons.fact_check,
      Icons.supervisor_account,
    ];

    List<String> texts = [
      lang.synchronize,
      lang.createOrder,
      lang.visitHistory,
      lang.stock,
      lang.returns,
      lang.customers,
    ];

    func3() {
      navigatorPushMethod(
        context,
        const SynchProgress(isAfterLogin: false),
        false,
      );
    }

    func4() {
      navigatorPushMethod(context, const SearchBP(), false);
    }

    func5() {
      navigatorPushMethod(context, ItemStock(), false);
    }

    func8() {
      navigatorPushMethod(context, 
      // TraderVisitsPage(),
      Center(),
       false);
    }

    func9() {
      navigatorPushMethod(context, const CustomersPage(), false);
    }

    func10() async {
      navigatorPushMethod(context, const ReturnObjectsPage(), false);
    }

    List<Function()?> functions = [
      func3,
      func4,
      func8,
      func5,
      func10,
      func9,
    ];

    return GridviewPart(texts: texts, functions: functions, icons: icons);
  }
}
