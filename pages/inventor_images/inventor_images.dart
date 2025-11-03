import 'package:flutter/material.dart';
import 'package:shaylan_agent/methods/gridview.dart';
import 'package:shaylan_agent/pages/inventor_images/parts/add_inventor_image_button.dart';
import 'package:shaylan_agent/pages/inventor_images/parts/result_inventor_images.dart';
import 'package:shaylan_agent/pages/visit_step_one.dart';

class InventorImagesPage extends StatelessWidget {
  const InventorImagesPage(
      {super.key, required this.visitID, required this.cardCode});

  final int visitID;
  final String cardCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Inwentoryn suratlary'),
        actions: [AddInventorImageButton(visitID: visitID, cardCode: cardCode)],
      ),
      body: ResultInventorImages(visitID: visitID),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => navigatorPushMethod(
            context, VisitStepOnePage(visitID: visitID), false),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
