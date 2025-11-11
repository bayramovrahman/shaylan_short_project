import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/pages/delivery/customer_delivery.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/delivery/delivery_products.dart';
import 'package:shaylan_agent/synchronization/synchprogres.dart';
import 'package:shaylan_agent/partial/gridview_part.dart';
import 'package:shaylan_agent/pages/delivery/payments/ekspeditor_payments_page.dart';

class MerchandaiserGrivew extends StatefulWidget {
  const MerchandaiserGrivew({super.key});

  @override
  State<MerchandaiserGrivew> createState() => _MerchandaiserGrivewState();
}

class _MerchandaiserGrivewState extends State<MerchandaiserGrivew> {
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
      lang.delivery,
      lang.payments,
      lang.loads,
    ];

    List<IconData> icons = [
      Icons.download,
      Icons.local_shipping,
      IconlyBold.wallet,
      CupertinoIcons.cube_box_fill,
    ];

    func1() {
      navigatorPushMethod(
        context,
        const SynchProgress(isAfterLogin: false),
        false,
      );
    }

    func3() {
      navigatorPushMethod(context, CustomerDelivery(user: user), false);
    }

    func4() {
      navigatorPushMethod(context, DeliveryProducts(),false);
    }

    func5() {
      navigatorPushMethod(context, EkspeditorPaymentsPage(), false);
    }

    List<Function()?> functions = [
      func1,
      func3,
      func5,
      func4,
    ];

    return GridviewPart(texts: texts, functions: functions, icons: icons);
  }
}
