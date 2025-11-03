// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shaylan_agent/constants/auto_position.dart';
import 'package:shaylan_agent/database/functions/get_cardname_by_cardcode.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/functions/permission.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/methods/timed_circular_loader.dart';
import 'package:shaylan_agent/models/customer.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/pages/list_actions_page.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/utilities/alert_utils.dart';

Future<void> startVisitForTraders(
  WidgetRef ref,
  BuildContext context,
  Customer customer,
  List<ProductGroups> selectedGroups,
  int groupLength,
) async {
  late VisitModel visit;
  String cardCode = customer.cardCode;
  String cardName = await getCardNameByCardCode(cardCode);
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 15));
    } catch (e) {
      position = null;
    }

    visit = VisitModel(
      startTime: DateTime.now().toIso8601String(),
      latitude: position?.latitude ?? AutoPosition.defaultLatitude,
      longitude: position?.longitude ?? AutoPosition.defaultLongitude,
      cardCode: cardCode,
      cardName: cardName,
      status: VisitPaymentStatus.dontSent,
    );

    int visitId = await createVisit(visit);

    VisitStepModel visitStepStarted = VisitStepModel(
      startTime: DateTime.now().toIso8601String(),
      name: 'visitStarted',
      visitID: visitId,
      description: position != null ? "Wizit başlady" : "Wizit başlady (GPS Alynmady)!",
    );

    await createVisitStep(visitStepStarted);
    List<VisitStepModel> steps = [];
    steps.add(visitStepStarted);
    visit = visit.copyWith(stepsList: steps);
    await prefs.setInt('visitID', visitId);

    ref.read(loadStartVisitProvider.notifier).state = false;
    if (context.mounted) {
      navigatorPushMethod(
        context,
        ListActionsPage(
          productGroups: selectedGroups,
          visit: visit,
          customer: customer,
        ),
        false,
      );
    }
  } catch (e) {
    ref.read(loadStartVisitProvider.notifier).state = false;
    if (context.mounted) {
      navigatorPushMethod(
        context,
        ListActionsPage(
          productGroups: selectedGroups,
          visit: VisitModel(
            startTime: DateTime.now().toIso8601String(),
            latitude: 0.0,
            longitude: 0.0,
            cardCode: cardCode,
            cardName: cardName,
            status: VisitPaymentStatus.dontSent,
            stepsList: [],
          ),
          customer: customer,
        ),
        false,
      );
    }
  }
}

class StartVisitButtonForTraders extends ConsumerWidget {
  const StartVisitButtonForTraders({
    super.key,
    required this.productGroups,
    required this.groupLength,
    required this.customer,
  });

  final List<ProductGroups> productGroups;
  final int groupLength;
  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    bool load = ref.watch(loadStartVisitProvider);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: load
        ? null
        : () async {
            ref.read(loadStartVisitProvider.notifier).state = true;
            
            try {
              bool hasPermission = await hasLocationPermission();
              if (!hasPermission) {
                final permission = await Geolocator.requestPermission();
                hasPermission = permission == LocationPermission.always || permission == LocationPermission.whileInUse;
                if (!hasPermission) {
                  ref.read(loadStartVisitProvider.notifier).state = false;
                  if (context.mounted) {
                    Navigator.pop(context);
                    AlertUtils.showWarningAlert(
                      context: context,
                      message: lang.allowLocationToStartVisit,
                      lang: lang,
                    );
                  }
                  return;
                }
              }

              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                AlertUtils.showScreenAlertDialog(
                  context: context,
                  message: lang.openLocation,
                  lang: lang,
                  onConfirm: () async {
                    await Geolocator.openLocationSettings();
                    serviceEnabled = await Geolocator.isLocationServiceEnabled();
                    if (!serviceEnabled) {
                      ref.read(loadStartVisitProvider.notifier).state = false;
                      return;
                    }

                    if (context.mounted) {
                      await startVisitForTraders(
                        ref,
                        context,
                        customer,
                        productGroups,
                        productGroups.length,
                      );
                    }
                  },
                );

                ref.read(loadStartVisitProvider.notifier).state = false;
                return;
              }

              if (context.mounted) {
                await startVisitForTraders(
                  ref,
                  context,
                  customer,
                  productGroups,
                  productGroups.length,
                );
              }
            } catch (e) {
              ref.read(loadStartVisitProvider.notifier).state = false;
              if (context.mounted) {
                navigatorPushMethod(
                  context,
                  ListActionsPage(
                    productGroups: productGroups,
                    visit: VisitModel(
                      startTime: DateTime.now().toIso8601String(),
                      latitude: 0.0,
                      longitude: 0.0,
                      cardCode: customer.cardCode,
                      cardName: await getCardNameByCardCode(customer.cardCode),
                      status: VisitPaymentStatus.dontSent,
                      stepsList: [],
                    ),
                    customer: customer,
                  ),
                  false,
                );
              }
            }
          },
      child: load
        ? SizedBox(
            height: 25,
            width: 25,
            child: TimedCircularLoader(durationInSeconds: 15),
          )
        : Text(
            lang.startVisit,
            style: const TextStyle(color: Colors.white),
          ),
    );
  }
}
