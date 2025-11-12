import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/pages/visit_history/parts/result_visit_history.dart';

class VisitHistoryPage extends StatelessWidget {
  const VisitHistoryPage({super.key, required this.isTrader});

  final bool isTrader;

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          lang.visitHistory,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.monserratBold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            IconlyLight.arrow_left_circle,
            color: Colors.white,
            size: 32.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ResultVisitHistory(
        isTrader: isTrader,
      ),
    );
  }
}
