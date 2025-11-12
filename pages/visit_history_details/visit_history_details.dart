import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/visit_history_details/parts/result_visit_history_details.dart';
import 'package:shaylan_agent/pages/visit_history_details/parts/visit_history_reviews.dart';
import 'package:shaylan_agent/pages/visit_history_inventor_images/visit_history_inventor_images.dart';

class VisitHistoryDetailsPage extends StatelessWidget {
  const VisitHistoryDetailsPage({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(lang.visitHistoryDetails),
        actions: [
          visit.hasInventor == 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () => navigatorPushMethod(
                      context,
                      VisitHistoryInventorImages(visit: visit),
                      false,
                    ),
                    child: const Icon(Icons.image, color: Colors.white),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            ResultVisitHistoryDetails(visit: visit),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                lang.reviewsOfVisit,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            VisitHistoryReviews(visit: visit),
          ],
        ),
      ),
    );
  }
}
