import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/main.dart';
import 'package:shaylan_agent/models/connstring.dart';
import 'package:shaylan_agent/models/param.dart';
import 'package:http/http.dart' as http;

class Terminal {
  final String itemCode, itemName, assetSerNo, assetGroup, account;

  Terminal({
    required this.itemCode,
    required this.itemName,
    required this.assetSerNo,
    required this.assetGroup,
    required this.account,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      itemCode: json['itemCode'],
      itemName: json['itemName'],
      assetSerNo: json['assetSerNo'],
      assetGroup: json['assetGroup'],
      account: json['account'],
    );
  }

  factory Terminal.defaultTerminal() {
    return Terminal(
      itemCode: '',
      itemName: '',
      assetSerNo: '',
      assetGroup: '',
      account: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemCode': itemCode,
      'itemName': itemName,
      'assetSerNo': assetSerNo,
      'assetGroup': assetGroup,
      'account': account,
    };
  }

  static Future<List<Terminal>> fetchTerminals(
    String token,
    BuildContext context,
  ) async {
    Param ipAddress = await getIpAddressRoot();
    final Uri uri = Uri.parse(
      'https://${ipAddress.stringVal}/mobileapi/PkoPaymentMobile/get_pos_terminal',
    );

    Map<String, String> headers = {'Authorization': token};
    http.Response response = await http.get(uri, headers: headers);
    debugPrint("terminalSynchronization status code: ${response.statusCode}");

    if (response.statusCode == 401) {
      await removeUsers();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return compute(parseProps, response.body);
  }

  static List<Terminal> parseProps(String responseBody) {
    var jsonData = json.decode(responseBody);
    final props = jsonData;

    return props
        .map<Terminal>((propJson) => Terminal.fromJson(propJson))
        .toList();
  }

  static void fetchCreditReports(String token, BuildContext context) {}
}
