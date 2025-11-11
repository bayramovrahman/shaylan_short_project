import 'package:flutter/material.dart';
import 'package:shaylan_agent/partial/input_part.dart';

class InputPhone2 extends StatelessWidget {
  const InputPhone2({
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
      maxLength: 9,
      keyboardType: TextInputType.phone,
      autofocus: autofocus ?? false,
      textAlignVertical: TextAlignVertical.center,
      // cursorColor: Colors.blueGrey,
      decoration: InputDecoration(
        prefixText: '+993',
        prefixIcon: icon,
        // prefixStyle: const TextStyle(color: Colors.blueGrey, fontSize: 18),
        focusedBorder: inputBorder(),
        border: inputBorder(),
        labelText: ' $label ',
        // labelStyle: const TextStyle(color: Colors.blueGrey),
        counterText: '',
      ),
      // validator: validatorFunc,
    );
  }
}
