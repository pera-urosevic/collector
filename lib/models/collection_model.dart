import 'package:collector/models/field_model.dart';
import 'package:collector/models/filter_model.dart';
import 'package:collector/models/importer_model.dart';
import 'package:collector/models/sort_model.dart';

class CollectionModel {
  String id;
  String template;
  List<FieldModel> fields;
  String filter;
  List<FilterModel> filters;
  List<ImporterModel> importers;
  List<Map<String, dynamic>> items;

  CollectionModel({
    required this.id,
    required this.template,
    required this.fields,
    required this.filter,
    required this.filters,
    required this.importers,
    required this.items,
  });

  factory CollectionModel.blank(String collectionId) {
    return CollectionModel(
      id: collectionId,
      template: '# {{ id }}\n\n{{{ content }}}\n',
      fields: [
        FieldModel(id: 'uid', defaultValue: '', type: FieldType.uid, index: false, search: false, data: {}),
        FieldModel(id: 'id', defaultValue: '', type: FieldType.id, index: true, search: true, data: {}),
        FieldModel(id: 'content', defaultValue: '', type: FieldType.text, index: false, search: true, data: {}),
        FieldModel(id: 'created', defaultValue: '', type: FieldType.datetime, index: true, search: false, data: {}),
        FieldModel(id: 'modified', defaultValue: '', type: FieldType.datetime, index: true, search: false, data: {}),
      ],
      filter: 'ID',
      filters: [FilterModel(id: 'ID', sort: SortModel(field: 'id', reverse: false), query: {})],
      importers: [],
      items: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'template': template,
      'fields': fields,
      'filter': filter,
      'filters': filters.map((filter) => filter.toJson()).toList(),
      'importers': importers,
      'items': items,
    };
  }

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'],
      template: json['template'],
      fields: (json['fields'] as List<dynamic>).map((j) => FieldModel.fromJson(j)).toList(),
      filter: json['filter'],
      filters: (json['filters'] as List<dynamic>).map((j) => FilterModel.fromJson(j)).toList(),
      importers: (json['importers'] as List<dynamic>).map((j) => ImporterModel.fromJson(j)).toList(),
      items: (json['items'] as List<dynamic>).map((j) => j as Map<String, dynamic>).toList(),
    );
  }
}
