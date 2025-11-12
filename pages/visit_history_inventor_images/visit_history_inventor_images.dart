import 'package:flutter/material.dart';
import 'package:shaylan_agent/models/visit.dart';
import 'package:shaylan_agent/pages/visit_history_inventor_images/parts/result_visit_history_inventor_images.dart';

class VisitHistoryInventorImages extends StatelessWidget {
  const VisitHistoryInventorImages({super.key, required this.visit});

  final VisitModel visit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Inventor suratlar'),
      ),
      body: ResultVisitHistoryInventorImages(visit: visit),
    );
  }
}
