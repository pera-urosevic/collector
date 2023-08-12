import 'package:flutter/foundation.dart';
import 'package:collector/models/collector_model.dart';
import 'package:collector/models/collection_model.dart';
import 'package:collector/services/storage_service.dart';

class CollectorProvider with ChangeNotifier {
  CollectorModel _collector = CollectorModel.blank();

  List<String> get collectionIds => _collector.collectionIds;

  int get size => _collector.collectionIds.length;

  CollectorProvider() {
    loadCollector();
  }

  loadCollector() async {
    List<String> collectionIds = await storage.list();
    if (kReleaseMode) {
      collectionIds = collectionIds.where((collectionId) => collectionId != 'Test').toList();
    }
    _collector = CollectorModel(collectionIds: collectionIds);
    notifyListeners();
  }

  createCollection(String collectionId) async {
    CollectionModel collection = CollectionModel.blank(collectionId);
    await storage.save(collection);
    loadCollector();
  }

  removeCollection(String collectionId) async {
    await storage.remove(collectionId);
    await loadCollector();
  }
}
