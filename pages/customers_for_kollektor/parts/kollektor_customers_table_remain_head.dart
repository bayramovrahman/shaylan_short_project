import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class KollektorCustomersTableRemainHead extends ConsumerWidget {
  const KollektorCustomersTableRemainHead({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData icon = Icons.swap_vert;
    var lang = AppLocalizations.of(context)!;
    String sortBalance = ref.watch(sortBalanceProvider);

    switch (sortBalance) {
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
        ref.read(sortExpiredDayProvider.notifier).state = '';
        if (sortBalance == 'DESC' || sortBalance == '') {
          ref.read(sortBalanceProvider.notifier).state = 'ASC';
          return;
        }
        ref.read(sortBalanceProvider.notifier).state = 'DESC';
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              lang.remainder,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.secondaryFont,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
