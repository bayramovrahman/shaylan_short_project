import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/inventor_images.dart';
import 'package:shaylan_agent/functions/file_upload.dart';
import 'package:shaylan_agent/methods/static_data.dart';
import 'package:shaylan_agent/models/inventor_image.dart';
import 'package:shaylan_agent/providers/database/inventor_image.dart';

class ResultInventorImages extends ConsumerWidget {
  const ResultInventorImages({super.key, required this.visitID});

  final int visitID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<InventorImage>> inventorImages =
        ref.watch(getInventorImagesByVisitIDProvider(visitID));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: inventorImages.when(
        data: (response) {
          return ListView.builder(
            itemCount: response.length,
            itemBuilder: (context, index) {
              InventorImage inventorImage = response[index];
              return Card(
                color: Colors.blue.shade300,
                child: ListTile(
                  title: Image.file(
                    File(inventorImage.imagePath!),
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                      await deleteFile(inventorImage.imagePath!);
                      await removeInventorImageById(inventorImage.id!);
                      ref.invalidate(
                          getInventorImagesByVisitIDProvider(visitID));
                    },
                    child: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => errorMethod(error),
        loading: () => loadWidget,
      ),
    );
  }
}
