import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/functions/file_upload.dart';
import 'package:shaylan_agent/models/user.dart';

class AddInventorImageButton extends ConsumerWidget {
  const AddInventorImageButton(
      {super.key, required this.visitID, required this.cardCode});

  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.green,
      ),
      onPressed: () async {
        User user = await getUser();

        String currentTime =
            DateFormat('dd-MM-yyyy_kkmmss').format(DateTime.now());
        String fileName = '${user.empId}-$cardCode-$visitID-$currentTime';

        await getImageFromCamera(ref, 3, 4, visitID, fileName);
      },
      child: const Icon(
        Icons.add_photo_alternate_outlined,
        color: Colors.white,
      ),
    );
  }
}
