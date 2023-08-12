class CollectorModel {
  List<String> collectionIds;

  int get size => collectionIds.length;

  CollectorModel({
    required this.collectionIds,
  });

  factory CollectorModel.blank() {
    return CollectorModel(
      collectionIds: [],
    );
  }
}
