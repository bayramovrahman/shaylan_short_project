import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/inventor_image.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/providers/database/inventor_image.dart';
import 'package:shaylan_agent/l10n/app_localizations.dart';

class ResultVisitHistoryInventorImages extends ConsumerWidget {
  const ResultVisitHistoryInventorImages({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var lang = AppLocalizations.of(context)!;

    AsyncValue<List<InventorImage>> inventorImages =
        ref.watch(getInventorImagesByVisitIDProvider(visit.id!));
    return inventorImages.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text(lang.noData));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisExtent: MediaQuery.of(context).size.width * .5,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => Image.file(
              File(data[index].imagePath!),
              height: MediaQuery.of(context).size.height * .2,
            ),
          ),
        );
      },
      error: (error, stackTrace) => errorMethod(error),
      loading: () => loadWidget,
    );
  }
}
