import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shaylan_agent/constants/auto_position.dart';
import 'package:shaylan_agent/database/functions/credit_report_line.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/models/static_data.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/pages/inventor/inventor.dart';
import 'package:shaylan_agent/pages/inventor/inventor_new_page.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';

Future<void> startVisit(
  String cardCode,
  WidgetRef ref,
  BuildContext context,
  {required String visitType}
) async {
  const double defaultLatitude = AutoPosition.defaultLatitude;
  const double defaultLongitude = AutoPosition.defaultLongitude;
  
  Position position;
  
  try {
    position = await Geolocator.getCurrentPosition().timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        return Position(
          longitude: defaultLongitude,
          latitude: defaultLatitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      },
    );
    
    if (position.latitude == defaultLatitude && position.longitude == defaultLongitude) {
      debugPrint('Using default coordinates after timeout');
    } else {
      debugPrint('Using actual GPS coordinates: ${position.latitude}, ${position.longitude}');
    }
  } catch (e) {
    debugPrint('Error getting location: $e');
    position = Position(
      longitude: defaultLongitude,
      latitude: defaultLatitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
  }

  String cardName = await getCreditReportLineClientByCardCode(cardCode);

  VisitModel visit = VisitModel(
    startTime: DateTime.now().toIso8601String(),
    latitude: position.latitude,
    longitude: position.longitude,
    cardCode: cardCode,
    cardName: cardName,
    status: VisitPaymentStatus.dontSent,
  );

  int visitID = await createVisit(visit);

  ref.read(loadStartVisitProvider.notifier).state = false;
  if (context.mounted) {
    if (visitType == "oldVisitType") {
      navigatorPushMethod(
        context,
        InventorPage(visitID: visitID, cardCode: cardCode),
        false,
      );
    } else {
      navigatorPushMethod(
        context,
        InventorNewPage(visitID: visitID, cardCode: cardCode),
        false,
      );
    }
  }
}
