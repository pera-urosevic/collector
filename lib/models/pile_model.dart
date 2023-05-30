import 'package:hoard/models/field_model.dart';
import 'package:hoard/models/filter_model.dart';
import 'package:hoard/models/forge_model.dart';
import 'package:hoard/models/sort_model.dart';

class PileModel {
  String id;
  String template;
  List<FieldModel> fields;
  String filter;
  List<FilterModel> filters;
  List<ForgeModel> forges;
  List<Map<String, dynamic>> artifacts;

  PileModel({
    required this.id,
    required this.template,
    required this.fields,
    required this.filter,
    required this.filters,
    required this.forges,
    required this.artifacts,
  });

  factory PileModel.blank(String pileId) {
    return PileModel(
      id: pileId,
      template: '# {{ id }}\n\n{{{ content }}}\n',
      fields: [
        FieldModel(id: 'id', defaultValue: '', type: FieldType.id, index: true, search: true, data: {}),
        FieldModel(id: 'content', defaultValue: '', type: FieldType.text, index: false, search: true, data: {}),
        FieldModel(id: 'created', defaultValue: '', type: FieldType.datetime, index: true, search: false, data: {}),
        FieldModel(id: 'modified', defaultValue: '', type: FieldType.datetime, index: true, search: false, data: {}),
      ],
      filter: 'ID',
      filters: [FilterModel(id: 'ID', sort: SortModel(field: 'id', reverse: false), query: {})],
      forges: [],
      artifacts: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'template': template,
      'fields': fields,
      'filter': filter,
      'filters': filters.map((filter) => filter.toJson()).toList(),
      'forges': forges,
      'artifacts': artifacts,
    };
  }

  factory PileModel.fromJson(Map<String, dynamic> json) {
    return PileModel(
      id: json['id'],
      template: json['template'],
      fields: (json['fields'] as List<dynamic>).map((j) => FieldModel.fromJson(j)).toList(),
      filter: json['filter'],
      filters: (json['filters'] as List<dynamic>).map((j) => FilterModel.fromJson(j)).toList(),
      forges: (json['forges'] as List<dynamic>).map((j) => ForgeModel.fromJson(j)).toList(),
      artifacts: (json['artifacts'] as List<dynamic>).map((j) => j as Map<String, dynamic>).toList(),
    );
  }
}
