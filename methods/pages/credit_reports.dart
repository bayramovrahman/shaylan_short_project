import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/start_visit_button.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/kollektor_customer_info_page.dart';

Padding tableHeaderMethod(String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13.0.sp,
        letterSpacing: 0.3,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: AppFonts.secondaryFont,
      ),
    ),
  );
}

Padding tableRowMethod(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    child: Text(text, textAlign: TextAlign.center),
  );
}

GestureDetector customersTableRowMethod(
    String text, BuildContext context, String cardCode) {
  return GestureDetector(
    onTap: () async {
      /* bool hasPermission = await hasLocationPermission();
      if (context.mounted) {
        showStartVisitDialog(context, hasPermission, cardCode);
      } */
      navigatorPushMethod(
        context,
        KollektorCustomerInfoPage(cardCode: cardCode),
        false,
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}

void showStartVisitBottomSheet(
    BuildContext context, bool hasPermission, String cardCode) {
  var lang = AppLocalizations.of(context)!;
  debugPrint("--------on_showStartVisitBottomSheet_method");

  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return GestureDetector(
        child: SizedBox(
          width: double.infinity,
          height: 120,
          child: Column(
            children: [
              const SizedBox(height: 20),
              !hasPermission
                  ? Text(
                      lang.allowLocationToStartVisit,
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      lang.cancel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontFamily: AppFonts.secondaryFont,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  StartVisitButton(cardCode: cardCode),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showStartVisitDialog(BuildContext context, bool hasPermission, String cardCode) {
  var lang = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: hasPermission
            ? const SizedBox()
            : Text(
                lang.allowLocationToStartVisit,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: AppFonts.monserratBold,
                  fontWeight: FontWeight.bold,
                ),
              ),
       content: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 40.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 4.w)
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: FittedBox(
                    child: Text(
                      lang.cancel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: AppFonts.secondaryFont,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: SizedBox(
                height: 40.h,
                child: StartVisitButton(cardCode: cardCode),
              ),
            ),
          ],
        ),
      ),

      );
    },
  );
}
