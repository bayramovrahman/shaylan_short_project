import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shaylan_agent/pages/customers/customers.dart';
import 'package:shaylan_agent/pages/item_stock.dart';
import 'package:shaylan_agent/pages/searchbp.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/synchronization/synchprogres.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/partial/gridview_part.dart';

class TradingAgentGrivew extends StatelessWidget {
  const TradingAgentGrivew({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    List<IconData?> icons = [
      Icons.download,
      // Icons.edit_document,
      Icons.edit_document,
      // Icons.description,
      Icons.warehouse,
      // Icons.summarize,
      Icons.supervisor_account,
      Icons.history,
      // Icons.replay
    ];

    List<String> texts = [
      lang.synchronize,
      // lang.actions,
      lang.createVisit,
      // lang.listOfOrders,
      lang.stock,
      //  lang.reportOfRemainingProducts,
      lang.customers,
      lang.visitHistory,
      // lang.returningTheProduct
    ];

    func3() {
      navigatorPushMethod(
        context,
        const SynchProgress(isAfterLogin: false),
        false,
      );
    }

    func4() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');
      debugPrint(token);
      if (context.mounted) {
        navigatorPushMethod(context, const SearchBP(), false);
      }
    }

    // func2() {
    //   navigatorPushMethod(context, const SearchBP(prevRoute: 'return-item'), false);
    // }

    // func1() {
    //   navigatorPushMethod(context, const SearchBP(prevRoute: 'left'), false);
    // }

    func5() {
      navigatorPushMethod(context, const ItemStock(), false);
    }

    /* func8() {
      navigatorPushMethod(context, const SendQueueProgress(), false);
    } */

    func9() {
      navigatorPushMethod(context, const CustomersPage(), false);
    }

    func11() {
      navigatorPushMethod(
          context,
          // VisitHistoryPage(isTrader: true,)
          // const TraderVisitsPage(),
          Center(),
          false);
    }

    List<Function()?> functions = [
      func3,
      // listActions,
      func4,
      // func8,
      func5,
      // func1,
      func9,
      func11,
      // func2
    ];

    return GridviewPart(texts: texts, functions: functions, icons: icons);
  }
}
