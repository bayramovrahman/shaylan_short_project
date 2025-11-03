import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/providers/pages/customer_balance_history.dart';

class CustomerBalanceHistoryTableDateHeader extends ConsumerWidget {
  const CustomerBalanceHistoryTableDateHeader({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData icon = Icons.arrow_downward;
    String sortDate = ref.watch(sortDateProvider);

    switch (sortDate) {
      case 'ASC':
        icon = Icons.arrow_downward;
        break;
      case 'DESC':
        icon = Icons.arrow_upward;
        break;
      default:
        icon = Icons.arrow_downward;
    }

    return GestureDetector(
      onTap: () async {
        if (sortDate == 'ASC') {
          ref.read(sortDateProvider.notifier).state = 'DESC';
          return;
        }
        ref.read(sortDateProvider.notifier).state = 'ASC';
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
