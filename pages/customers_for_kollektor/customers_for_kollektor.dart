import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:shaylan_agent/app/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';
import 'package:shaylan_agent/pages/customers/parts/customers_search_button.dart';
import 'package:shaylan_agent/pages/customers/parts/search_customers_input.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/filter_district_button.dart';
import 'package:shaylan_agent/pages/customers_for_kollektor/parts/result_customers_for_kollektor.dart';

class CustomersForKollektorPage extends ConsumerWidget {
  const CustomersForKollektorPage({
    super.key,
    this.root,
    required this.visitType,
  });

  final String? root;
  final String visitType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;
    bool openSearch = ref.watch(openCustomersSearchProvider);
    debugPrint("--ui_CustomersForKollektorPage--");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: openSearch
            ? const SearchCustomersInput()
            : Text(
                lang.customers,
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
        actions: [
          const CustomersSearchButton(),
          FilterDistrictButton(root: root ?? ''),
        ],
      ),
      body: ResultCustomersForKollektor(root: root, visitType: visitType),
    );
  }
}
