import 'package:collector/models/sort_model.dart';

class FilterModel {
  String id;
  SortModel sort;
  Map<String, dynamic> query;

  FilterModel({
    required this.id,
    required this.sort,
    required this.query,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sort': sort.toJson(),
      'query': query,
    };
  }

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      id: json['id'],
      sort: SortModel(
        field: json['sort']['field'],
        reverse: json['sort']['reverse'],
      ),
      query: json['query'],
    );
  }
}
