import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/database/functions/inventor_images.dart';
import 'package:shaylan_agent/database/functions/user.dart';
import 'package:shaylan_agent/database/functions/visit.dart';
import 'package:shaylan_agent/database/functions/visit_payment.dart';
import 'package:shaylan_agent/database/functions/visit_step.dart';
import 'package:shaylan_agent/methods/snackbars.dart';
import 'package:shaylan_agent/models/inventor_image.dart';
import 'package:shaylan_agent/models/user.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/models/visit_payment.dart';
import 'package:shaylan_agent/models/visit_step.dart';
import 'package:shaylan_agent/synchronization/synh.dart';
import 'package:shaylan_agent/providers/database/visit.dart';
import 'package:shaylan_agent/providers/local_storadge.dart';
import 'package:shaylan_agent/providers/pages/visit_steps.dart';

class SendVisitButton extends ConsumerWidget {
  const SendVisitButton({super.key, required this.visitID});

  final int visitID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        ref.read(loadSendVisitrovider.notifier).state = true;
        String token = ref.read(tokenProvider);
        VisitModel? dbVisit = await getVisitByID(visitID);
        List<InventorImage> images = [];
        List<VisitPayment> vps = [];

        if (dbVisit != null) {
          User user = await getUser();

          List<VisitStepModel> visitSteps =
              await getVisitStepsByVisitID(visitID);

          List<InventorImage> inventorImages =
              await getInventorImagesByVisitID(visitID);

          if (inventorImages.isNotEmpty) {
            for (var element in inventorImages) {
              File imageFile = File(element.imagePath!);
              List<int> imageBytes = await imageFile.readAsBytes();
              String base64String = base64Encode(imageBytes);
              InventorImage inventorImage =
                  element.copyWith(imageBytes: base64String);
              images.add(inventorImage);
            }
          }

          List<VisitPayment> visitPayments =
              await getVisitPaymentsByVisitID(visitID);

          if (visitPayments.isNotEmpty) {
            for (var element in visitPayments) {
              vps.add(element.copyWith(empID: user.empId));
            }
          }

          VisitModel visit = dbVisit.copyWith(
            empID: user.empId,
            empName: user.firstName,
            empLastName: user.lastName,
            stepsList: visitSteps,
            imagesList: images,
            paymentsList: vps,
          );
          // ignore: use_build_context_synchronously
          final result = await sendVisit(visit, token, context, visitID);
          if (context.mounted) {
            if (result) {
              ref.invalidate(getDontSentVisitsProvider);
            } else {
              showSomeErrSnackBar(context);
            }
          }
        }

        ref.read(loadSendVisitrovider.notifier).state = false;
      },
      child: const Icon(Icons.send, color: Colors.blue),
    );
  }
}
