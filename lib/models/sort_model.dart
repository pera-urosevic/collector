class SortModel {
  String field;
  bool reverse;

  SortModel({
    required this.field,
    required this.reverse,
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'reverse': reverse,
    };
  }

  factory SortModel.fromJson(Map<String, dynamic> json) {
    return SortModel(
      field: json['field'],
      reverse: json['reverse'],
    );
  }
}
