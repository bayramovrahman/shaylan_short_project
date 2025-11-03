import 'package:flutter/material.dart';

PopupMenuItem<String> districtFilterMethod(
    String text, String value, String selectedDistrict, Function() onTap) {
  return PopupMenuItem<String>(
    onTap: onTap,
    value: value,
    child: ListTile(
      title: Text(text),
      trailing: selectedDistrict == value
          ? const Icon(Icons.check, color: Colors.green)
          : null,
    ),
  );
}
