import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/pages/credit_reports/credit_reports.dart';

class SelectPaymentTypeButton extends StatelessWidget {
  const SelectPaymentTypeButton(
      {super.key, required this.cardCode, required this.visitID, });

  final String cardCode;
  final int visitID;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.all(15),
        elevation: 6,
      ),
      onPressed: () => navigatorPushMethod(
        context,
        CreditReportsPage(
          cardCode: cardCode,
          visitID: visitID,
        ),
        false,
      ),
      child: const Text(
        'Toleg gornusini sayla',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
