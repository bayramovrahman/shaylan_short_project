import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/database/functions/customer.dart';
import 'package:shaylan_agent/models/customer_by_card_code.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/utilities/error_utils.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/kollektor_customer_detail_page.dart';

class KollektorCustomerInfoPage extends ConsumerStatefulWidget {
  final String cardCode;

  const KollektorCustomerInfoPage({
    super.key,
    required this.cardCode,
  });

  @override
  ConsumerState<KollektorCustomerInfoPage> createState() =>
      _KollektorCustomerInfoPageState();
}

class _KollektorCustomerInfoPageState
    extends ConsumerState<KollektorCustomerInfoPage> {
  // Just empty column

  bool hasInternetConnection = false;
  User user = User.defaultUser();
  late String token;
  CustomerByCardCode? customer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomerFromCardCodeDb();
  }

  Future<void> loadCustomerFromCardCodeDb() async {
    CustomerByCardCode? result =
        await getCustomerByCardCodeLocal(widget.cardCode);
    setState(() {
      customer = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var lang = AppLocalizations.of(context)!;
    // debugPrint("Token: $token");
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (customer == null || customer!.cardCode == "") {
      return Scaffold(
        body: Center(
          child: ErrorUtils.settingsErrorMessage(message: lang.notFound),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          lang.infoCustomer,
          style: TextStyle(
            fontFamily: AppFonts.secondaryFont,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
      body: KollektorCustomerDetailPage(kollektorCustomer: customer!),
    );
  }

  // Just empty column
}
