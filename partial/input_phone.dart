import 'package:flutter/material.dart';
import 'package:shaylan_agent/partial/input_part.dart';

class InputPhone extends StatelessWidget {
  const InputPhone({
    super.key,
    required this.ctrl,
    required this.label,
    this.validatorFunc,
    this.autofocus,
    this.icon,
  });

  final TextEditingController ctrl;
  final String label;
  final String? Function(String?)? validatorFunc;
  final bool? autofocus;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      maxLength: 8,
      keyboardType: TextInputType.phone,
      autofocus: autofocus ?? false,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        prefixText: '+993',
        prefixIcon: icon,
        focusedBorder: inputBorder(),
        border: inputBorder(),
        labelText: ' $label ',
        counterText: '',
      ),
      validator: validatorFunc,
    );
  }
}
