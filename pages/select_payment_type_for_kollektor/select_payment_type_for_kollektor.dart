import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/database/functions/visit_payment.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/pages/select_payment_type_for_kollektor/parts/payment_type_list_tile.dart';
import 'package:shaylan_agent/pages/select_payment_type_for_kollektor/parts/select_payment_type_button.dart';

class SelectPaymentTypeForKollektorPage extends StatelessWidget {
  const SelectPaymentTypeForKollektorPage({
    super.key,
    required this.cardCode,
    required this.visitID,
  });

  final String cardCode;
  final int visitID;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await removeVisitPaymentsByVisitID(visitID);
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            lang.paymentOption,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaymentTypeListTile(
                paymentType: VisitPaymentType.nagt,
                title: lang.cashPayment,
              ),
              PaymentTypeListTile(
                paymentType: VisitPaymentType.terminal,
                title: lang.terminal,
              ),
              PaymentTypeListTile(
                paymentType: VisitPaymentType.perecesleniya,
                title: lang.enumeration,
              ),
              const SizedBox(height: 50),
              SelectPaymentTypeButton(
                cardCode: cardCode,
                visitID: visitID,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
