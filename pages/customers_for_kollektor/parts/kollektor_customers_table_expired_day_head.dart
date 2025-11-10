import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class KollektorCustomersTableExpiredDayHead extends ConsumerWidget {
  const KollektorCustomersTableExpiredDayHead({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    IconData icon = Icons.swap_vert;
    String sortExpiredDay = ref.watch(sortExpiredDayProvider);

    switch (sortExpiredDay) {
      case 'ASC':
        icon = Icons.arrow_downward;
        break;
      case 'DESC':
        icon = Icons.arrow_upward;
        break;
      default:
        icon = Icons.swap_vert;
    }

    return GestureDetector(
      onTap: () async {
        ref.read(sortBalanceProvider.notifier).state = '';

        if (sortExpiredDay == 'DESC' || sortExpiredDay == '') {
          ref.read(sortExpiredDayProvider.notifier).state = 'ASC';
          return;
        }
        ref.read(sortExpiredDayProvider.notifier).state = 'DESC';
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lang.expiredDay,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.monserratBold,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
