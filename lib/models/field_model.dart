enum FieldType {
  id,
  boolean,
  date,
  datetime,
  string,
  text,
  markdown,
  list,
  select,
  tags,
  image,
}

class FieldModel {
  String id;
  FieldType type;
  dynamic defaultValue;
  bool index;
  bool search;
  dynamic data;

  FieldModel({
    required this.id,
    required this.type,
    required this.defaultValue,
    required this.index,
    required this.search,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'defaultValue': defaultValue,
      'index': index,
      'search': search,
      'data': data,
    };
  }

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'],
      type: FieldType.values.byName(json['type']),
      defaultValue: json['defaultValue'],
      index: json['index'],
      search: json['search'],
      data: json['data'],
    );
  }
}
