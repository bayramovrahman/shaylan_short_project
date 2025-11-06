import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shaylan_agent/models/inventor_image.dart';
import 'package:shaylan_agent/services/database/inventor_images.dart';

final inventorImageDBProvider =
    Provider<InventorImageDBService>((ref) => InventorImageDBService());

final getInventorImagesByVisitIDProvider =
    FutureProvider.autoDispose.family<List<InventorImage>, int>(
  (ref, arg) =>
      ref.read(inventorImageDBProvider).getInventorImagesByVisitID(arg),
);
