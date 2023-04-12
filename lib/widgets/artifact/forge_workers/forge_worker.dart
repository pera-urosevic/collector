import 'package:hoard/models/artifact_model.dart';

abstract class ForgeWorker {
  Future<List<Map>> search(String query);
  Future<ArtifactModel> fetch(Map ref);
}
