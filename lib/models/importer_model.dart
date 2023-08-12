typedef ImportingModel = Map<String, dynamic>;

class ImporterModel {
  String id;
  List<String> fields;

  ImporterModel({
    required this.id,
    required this.fields,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fields': fields,
    };
  }

  factory ImporterModel.fromJson(Map<String, dynamic> json) {
    return ImporterModel(
      id: json['id'],
      fields: (json['fields'] as List<dynamic>).map((j) => j as String).toList(),
    );
  }
}
