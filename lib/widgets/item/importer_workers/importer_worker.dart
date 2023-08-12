import 'package:collector/models/item_model.dart';

abstract class ImporterWorker {
  Future<List<Map>> search(String query);
  Future<ItemModel> fetch(Map ref);
}
