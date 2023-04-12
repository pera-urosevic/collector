typedef ForgingModel = Map<String, dynamic>;

class ForgeModel {
  String id;
  List<String> fields;

  ForgeModel({
    required this.id,
    required this.fields,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fields': fields,
    };
  }

  factory ForgeModel.fromJson(Map<String, dynamic> json) {
    return ForgeModel(
      id: json['id'],
      fields: (json['fields'] as List<dynamic>).map((j) => j as String).toList(),
    );
  }
}
