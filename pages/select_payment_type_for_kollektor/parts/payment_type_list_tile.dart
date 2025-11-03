import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/providers/pages/select_payment_type_for_kollektor.dart';

class PaymentTypeListTile extends ConsumerWidget {
  const PaymentTypeListTile({
    super.key,
    required this.paymentType,
    required this.title,
  });

  final String paymentType, title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String selectedPaymentType = ref.watch(selectedPaymentTypeProvider);
    return Card(
      color: Theme.of(context).primaryColor,
      child: RadioListTile(
        activeColor: Colors.white,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: paymentType,
        groupValue: selectedPaymentType,
        onChanged: (value) =>
            ref.read(selectedPaymentTypeProvider.notifier).state = paymentType,
      ),
    );
  }
}
