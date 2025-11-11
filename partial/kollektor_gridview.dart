import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shaylan_agent/database/functions/customer.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/pages/customer_roots.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/customers_for_kollektor.dart';
import 'package:shaylan_agent/pages/daily_visit_report/daily_visit_report.dart';
import 'package:shaylan_agent/pages/item_stock.dart';
import 'package:shaylan_agent/pages/return_objects/return_objects.dart';
import 'package:shaylan_agent/pages/searchbp.dart';
import 'package:shaylan_agent/synchronization/synchprogres.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/terminals/terminals.dart';
import 'package:shaylan_agent/pages/visit_history/visit_history.dart';
import 'package:shaylan_agent/pages/waiting_visits/waiting_visits.dart';
import 'package:shaylan_agent/partial/gridview_part.dart';
import 'package:shaylan_agent/utilities/alert_utils.dart';

class KollektorGridview extends StatelessWidget {
  const KollektorGridview({super.key});

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    List<IconData?> icons = [
      Icons.download,
      Icons.supervisor_account,
      Icons.ballot,
      Icons.history,
      Icons.grading,
      Icons.warehouse,
      Icons.replay,
      Icons.summarize_outlined,
      Icons.undo,
      CupertinoIcons.creditcard
      // Icons.confirmation_num
    ];

    List<String> texts = [
      lang.synchronize,
      lang.customers,
      lang.terminals,
      lang.visitHistory,
      lang.waitingVisits,
      lang.stock,
      lang.returningTheProduct,
      lang.dailyReport,
      lang.returns,
      "Täze Töleg",
      // 'Tassyklamak'
    ];

    func3() {
      navigatorPushMethod(
        context,
        const SynchProgress(isAfterLogin: false),
        false,
      );
    }

    func4() async {
      debugPrint("--func4--");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String terminal = prefs.getString('terminal') ?? '';
      if (terminal == '' && context.mounted) {
        AlertUtils.showScreenVisitAlertDialog(
          context: context,
          message: 'Siz Terminal saýlamadyňyz, terminal bölümine girip, Terminal saýlaň!',
          lang: lang,
          onConfirm: () {
            null;
          },
        );
      } else {
        List<String> customerRoots = await getCustomerRoots();
        if ((customerRoots.length == 1 || customerRoots.isEmpty) &&
            context.mounted) {
          navigatorPushMethod(
            context,
            CustomersForKollektorPage(root: customerRoots.first, visitType: "oldVisitType"), 
            false,
          );
          return;
        }
        if (context.mounted) {
          navigatorPushMethod(
            context,
            CustomerRootsPage(customerRoots: customerRoots, visitType: "oldVisitType"),
            false,
          );
        }
      }
    }

    func15() async {
      debugPrint("--func4--");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String terminal = prefs.getString('terminal') ?? '';
      if (terminal == '' && context.mounted) {
        AlertUtils.showScreenVisitAlertDialog(
          context: context,
          message: 'Siz Terminal saýlamadyňyz, terminal bölümine girip, Terminal saýlaň!',
          lang: lang,
          onConfirm: () {
            null;
          },
        );
      } else {
        List<String> customerRoots = await getCustomerRoots();
        if ((customerRoots.length == 1 || customerRoots.isEmpty) && context.mounted) {
          navigatorPushMethod(
            context,
            CustomersForKollektorPage(root: customerRoots.first, visitType: "newVisitType"),
            false,
          );
          return;
        }
        if (context.mounted) {
          navigatorPushMethod(
            context,
            CustomerRootsPage(customerRoots: customerRoots, visitType: "newVisitType"),
            false,
          );
        }
      }
    }

    func10() {
      navigatorPushMethod(
          context, const TerminalsPage(isAfterLogin: false), false);
    }

    func11() {
      navigatorPushMethod(
          context,
          const VisitHistoryPage(
            isTrader: false,
          ),
          // GetMethod(),
          false);
    }

    func12() {
      navigatorPushMethod(context, const WaitingVisitsPage(), false);
    }

    func1(){
      navigatorPushMethod(context, ItemStock(), false);
    }

    func2() {
      navigatorPushMethod(context, const SearchBP(prevRoute: 'return-item'), false);
    }

    func13() {
      navigatorPushMethod(context, const DailyVisitReport(), false);
    }

    func14() {
      navigatorPushMethod(context, ReturnObjectsPage(), false);
    }

    /* func17() {
      navigatorPushMethod(context,  GetMethod(), false);
    } */

    List<Function()?> functions = [
      func3,
      func4,
      func10,
      func11,
      func12,
      func1,
      func2,
      func13,
      func14,
      func15,
    ];

    return GridviewPart(texts: texts, functions: functions, icons: icons);
  }
}
