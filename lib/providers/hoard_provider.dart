import 'package:flutter/foundation.dart';
import 'package:hoard/models/hoard_model.dart';
import 'package:hoard/models/pile_model.dart';
import 'package:hoard/services/storage_service.dart';

class HoardProvider with ChangeNotifier {
  HoardModel _hoard = HoardModel.blank();

  List<String> get pileIds => _hoard.pileIds;

  int get size => _hoard.pileIds.length;

  HoardProvider() {
    loadHoard();
  }

  loadHoard() async {
    List<String> pileIds = await storage.list();
    if (kReleaseMode) {
      pileIds = pileIds.where((pileId) => pileId != 'Test').toList();
    }
    _hoard = HoardModel(pileIds: pileIds);
    notifyListeners();
  }

  createPile(String pileId) async {
    PileModel pile = PileModel.blank(pileId);
    await storage.save(pile);
    loadHoard();
  }

  removePile(String pileId) async {
    await storage.remove(pileId);
    await loadHoard();
  }
}
