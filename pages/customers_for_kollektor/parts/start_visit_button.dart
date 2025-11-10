import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/functions/parts/start_visit.dart';
import 'package:shaylan_agent/functions/permission.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/methods/timed_circular_loader.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';

class StartVisitButton extends ConsumerWidget {
  const StartVisitButton({
    super.key,
    required this.cardCode,
    required this.visitType,
  });

  final String cardCode;
  final String visitType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    bool load = ref.watch(loadStartVisitProvider);

   return ElevatedButton(
    style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 8.w),
  ),
      onPressed: load
          ? null
          : () async {
              ref.read(loadStartVisitProvider.notifier).state = true;
              int counter = 0;

              do {
                if (await hasLocationPermission() && context.mounted) {
                  await startVisit(cardCode, ref, context, visitType: visitType);
                  return;
                }

                await Geolocator.requestPermission().then(
                  (value) async {
                    if ((value == LocationPermission.always ||
                            value == LocationPermission.whileInUse) &&
                        context.mounted) {
                      await startVisit(cardCode, ref, context, visitType: visitType);
                      return;
                    }
                  },
                );

                counter++;
              } while (!await hasLocationPermission() && counter < 3);
              ref.read(loadStartVisitProvider.notifier).state = false;
            },
      child: load
          ? SizedBox(height: 25.h, width: 25.w, child: TimedCircularLoader(durationInSeconds: 15,))
          : Text(
              lang.startVisit,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontFamily: AppFonts.secondaryFont,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
    );
  }
}
