import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:shaylan_agent/methods/pages/customers.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/providers/database/credit_report_line.dart';
import 'package:shaylan_agent/providers/pages/customers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class FilterDistrictButton extends ConsumerWidget {
  const FilterDistrictButton({super.key, required this.root});

  final String root;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    AsyncValue<List<String>> districts =
        ref.watch(getDistrictsByRootProvider(root));
    String selectedDistrict = ref.watch(districtFilterProvider);

    return districts.when(
      data: (response) {
        return PopupMenuButton(
          popUpAnimationStyle:
              AnimationStyle(curve: Curves.fastEaseInToSlowEaseOut),
          color: Colors.white,
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 4),
          elevation: 6,
          itemBuilder: (context) => [
            districtFilterMethod(
              lang.selectAll,
              '',
              selectedDistrict,
              () {
                ref.read(districtFilterProvider.notifier).state = '';
              },
            ),
            ...response.map((e) => districtFilterMethod(
                  e,
                  e,
                  selectedDistrict,
                  () {
                    ref.read(districtFilterProvider.notifier).state = e;
                  },
                )),
          ],
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child:
                Icon(IconlyBold.filter, color: Theme.of(context).primaryColor),
          ),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
