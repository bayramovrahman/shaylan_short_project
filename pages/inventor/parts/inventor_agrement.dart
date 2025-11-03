import 'package:flutter/material.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/pages/inventor/parts/inventor_page_button.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/inventor_images/inventor_images.dart';

class InventorAgrementPage extends StatelessWidget {
  const InventorAgrementPage(
      {super.key, required this.visitID, required this.cardCode});

  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${lang.hasInventorContract} ?',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InventorPageButton(
                text: lang.no,
                onPressed: () async {
                  await updateVisitHasInventorContract(0);
                  if (context.mounted) {
                    navigatorPushMethod(
                      context,
                      InventorImagesPage(
                        visitID: visitID,
                        cardCode: cardCode,
                      ),
                      false,
                    );
                  }
                },
              ),
              const SizedBox(width: 50),
              InventorPageButton(
                text: lang.yes,
                onPressed: () async {
                  await updateVisitHasInventorContract(1);
                  if (context.mounted) {
                    navigatorPushMethod(
                      context,
                      InventorImagesPage(
                        visitID: visitID,
                        cardCode: cardCode,
                      ),
                      false,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
