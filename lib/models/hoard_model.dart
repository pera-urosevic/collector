class HoardModel {
  List<String> pileIds;

  int get size => pileIds.length;

  HoardModel({
    required this.pileIds,
  });

  factory HoardModel.blank() {
    return HoardModel(
      pileIds: [],
    );
  }
}
