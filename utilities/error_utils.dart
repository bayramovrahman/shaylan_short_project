import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';

class ErrorUtils {
  // Just empty column
  
  ErrorUtils._();

  static Center settingsErrorMessage({required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: Lottie.asset('assets/lotties/settings_phone.json'),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: AppFonts.secondaryFont,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  static Center noInternetMessage({required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Lottie.asset(
              'assets/lotties/no_internet.json',
              repeat: false,
            ),
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: AppFonts.secondaryFont,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Just empty column
}