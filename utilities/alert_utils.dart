import 'dart:ui';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/constants/asset_path.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/pages/delivery/customer_delivery.dart';

class AlertUtils {
  // Just empty column

  AlertUtils._();

  static void showSnackBarError({
    required BuildContext context,
    required String message,
    required int second,
  }) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      duration: Duration(seconds: second),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.monserratBold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSnackBarWarning({
    required BuildContext context,
    required String message,
    required int second,
  }) {
    final snackBar = SnackBar(
      backgroundColor: Colors.orange,
      duration: Duration(seconds: second),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: AppFonts.monserratBold,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSnackBarSuccess({
    required BuildContext context,
    required String message,
    required int second,
  }) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: second),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: AppFonts.monserratBold,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccessAlert({
    required BuildContext context,
    required String message,
    required AppLocalizations lang,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/success.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  fontFamily: AppFonts.secondaryFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(lang.ok),
            ),
          ],
        );
      },
    );
  }

  static void showSuccessAlertWithNavigation({
    required BuildContext context,
    required String message,
    required AppLocalizations lang,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/success.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  fontFamily: AppFonts.secondaryFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async{
                User user = await getUser();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) => CustomerDelivery(user: user)),
                    (route) => false,
                  );
                  // navigatorPushMethod(context, CustomerDelivery(user: user), true);
                }
              },
              child: Text(lang.ok),
            ),
          ],
        );
      },
    );
  }

  static void showWarningAlert({
    required BuildContext context,
    required String message,
    required AppLocalizations lang,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AssetPath.warningAlert,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: AppFonts.secondaryFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(lang.ok),
            ),
          ],
        );
      },
    );
  }

  static void showErrorAlert({
    required BuildContext context,
    required String message,
    required AppLocalizations lang,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/lotties/unsuccessfully.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: AppFonts.secondaryFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(lang.ok),
            ),
          ],
        );
      },
    );
  }

  static Widget showSendLoading({required String message}) {
    return Center(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$message .....',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: AppFonts.monserratBold,
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget showSendPaperLoadingAnimation() {
    return Center(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.2),
            ),
          ),
          Center(
            child: Lottie.asset(
              AssetPath.loadingPaperAnimation,
              width: 500,
              height: 500,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  static Widget showSendSquareLoadingAnimation() {
    return Center(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.2),
            ),
          ),
          Center(
            child: Lottie.asset(
              AssetPath.loadingSquareAnimation,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  static void showScreenAlertDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
    required AppLocalizations lang,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Lottie.asset(
            AssetPath.warningAlert,
            width: 125.0,
            height: 125.0,
            fit: BoxFit.contain,
            repeat: false,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: AppFonts.secondaryFont,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.no,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.yes,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showScreenVisitAlertDialog({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirm,
    required AppLocalizations lang,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Lottie.asset(
            AssetPath.warningAlert,
            width: 125.0,
            height: 125.0,
            fit: BoxFit.contain,
            repeat: false,
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              fontFamily: AppFonts.secondaryFont,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'ok',
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget notFoundTask({required String description}) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          AssetPath.notFoundTaskAnimation,
          width: 250.0.w,
          repeat: false,
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 18.0.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.secondaryFont,
          ),
        )
      ],
    ));
  }

  static void noInternetConnection({
    required BuildContext context,
    required String message,
    required AppLocalizations lang,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AssetPath.noInternetAnimation,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: AppFonts.secondaryFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(lang.ok),
            ),
          ],
        );
      },
    );
  }

  static void holdOnFiveSeconds({
    required BuildContext context,
  }) {
    var lang = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AssetPath.threeSecondAnimation,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                repeat: false,
              ),
              Text(
                lang.alertToken,
                style: const TextStyle(
                  fontFamily: AppFonts.secondaryFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<bool?> showConfirmationVisit({
    required BuildContext context,
    required String message,
    required AppLocalizations lang,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AssetPath.warningAlert,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: AppFonts.secondaryFont,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.no,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.yes,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showConfirmDialog({
    required BuildContext context,
    required AppLocalizations lang,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            lang.save,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0.sp,
              fontFamily: AppFonts.monserratBold,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          content: Text(
            lang.areYouSure,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0.sp,
              fontFamily: AppFonts.secondaryFont,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.no,
                style: TextStyle(
                  fontSize: 13.0.sp,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.yes,
                style: TextStyle(
                  fontSize: 13.0.sp,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget showSendSquareLoadingAnimationWithProgress({
    required int totalItems,
    required int currentItem,
    required double totalAmount,
    required double processedAmount,
    String? currentProcessingText,
    required AppLocalizations lang,
  }) {
    final progress = totalItems > 0 ? currentItem / totalItems : 0.0;
    
    return Center(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.2),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  AssetPath.loadingSquareAnimation,
                  width: 200.w,
                  height: 200.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      SizedBox(height: 5.h),
                      if (currentProcessingText != null) ...[
                        Text(
                          currentProcessingText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            fontFamily: AppFonts.monserratBold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> showDeletePaymentConfirmation({
    required BuildContext context,
    required String message,
    required AppLocalizations lang,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                AssetPath.warningAlert,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                repeat: false,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontFamily: AppFonts.monserratBold,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.no,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(
                lang.yes,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontFamily: AppFonts.secondaryFont,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  // Just empty column
}
