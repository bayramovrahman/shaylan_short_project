import 'package:flutter/material.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/app/app_fonts.dart';

class InputPart extends StatefulWidget {
  const InputPart({
    super.key,
    required this.ctrl,
    this.validatorFunc,
    required this.label,
    this.keyboardType,
    this.maxLines,
    this.isRequired = false,
    this.isReadOnly = false,
    this.icon,
    this.onChanged,
    this.maxLength,
  });

  final TextEditingController ctrl;
  final String? Function(String?)? validatorFunc;
  final String label;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool isRequired;
  final Icon? icon;
  final bool isReadOnly;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  @override
  State<InputPart> createState() => _InputPartState();
}

class _InputPartState extends State<InputPart> {
  // Just empty column

  late int _currentLength;

  @override
  void initState() {
    super.initState();
    _currentLength = widget.ctrl.text.length;
    widget.ctrl.addListener(_updateLength);
  }

  void _updateLength() {
    if (mounted) {
      setState(() {
        _currentLength = widget.ctrl.text.length;
      });
    }
  }

  @override
  void dispose() {
    widget.ctrl.removeListener(_updateLength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    return Stack(
      children: [
        TextFormField(
          autofocus: false,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength,
          controller: widget.ctrl,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textAlignVertical: TextAlignVertical.center,
          readOnly: widget.isReadOnly,
          decoration: InputDecoration(
            focusedBorder: inputBorder(),
            border: inputBorder(),
            labelText:
                widget.isRequired ? ' ${widget.label} ' : ' ${widget.label}',
            prefixIcon: widget.icon,
            counterText: "",
          ),
          validator: widget.validatorFunc ??
              (value) {
                if (widget.isRequired && (value == null || value.isEmpty)) {
                  return lang.fieldRequired;
                }
                return null;
              },
          onChanged: widget.onChanged,
        ),
        if (widget.maxLength != null)
          Positioned(
            right: 10,
            bottom: 20,
            child: Text(
              '$_currentLength / ${widget.maxLength}',
              style: TextStyle(
                fontSize: 12.0,
                fontFamily: AppFonts.secondaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

OutlineInputBorder inputBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
}
