import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collector/models/item_model.dart';
import 'package:collector/models/field_model.dart';
import 'package:collector/models/filter_model.dart';
import 'package:collector/models/importer_model.dart';
import 'package:collector/models/collection_model.dart';
import 'package:collector/services/storage_service.dart';

class CollectionProvider with ChangeNotifier {
  String _search = '';
  CollectionModel _collection = CollectionModel.blank('Blank');
  List<FieldModel> _fieldsIndex = [];
  List<FieldModel> _fieldsSearch = [];
  Map<String, List<String>> _lookups = {};
  Set<String> _itemUids = {};
  List<ItemModel> _items = [];

  // cache fields

  List<FieldModel> get fieldsIndex => _fieldsIndex;
  List<FieldModel> get fieldsSearch => _fieldsSearch;

  _cacheFields() {
    _fieldsIndex = _collection.fields.where((field) => field.index).toList();
    _fieldsSearch = _collection.fields.where((field) => field.search).toList();
  }

  // cache lookups

  Map<String, List<String>> get lookups => _lookups;

  _cacheLookups() {
    _lookups = {};
    for (FieldModel field in _collection.fields) {
      Set<String> set = Set.from(field.data['options'] ?? {});
      switch (field.type) {
        case FieldType.select:
          for (ItemModel item in _collection.items) {
            String value = item[field.id].toString();
            set.add(value);
          }
          _lookups[field.id] = set.toList();
          _lookups[field.id]?.sort((a, b) => a.compareTo(b));
          break;
        case FieldType.tags:
          for (ItemModel item in _collection.items) {
            List<String> values = List<String>.from(item[field.id].map((value) => value.toString()));
            set.addAll(values);
          }
          _lookups[field.id] = set.toList();
          _lookups[field.id]?.sort((a, b) => a.compareTo(b));
          break;
        default:
          break;
      }
    }
  }

  // cache items

  Set<String> get itemUids => _itemUids;

  _cacheItemIds() {
    _itemUids = Set.from(_collection.items.map((item) => item['uid']));
  }

  List<ItemModel> get items => _items;
  _cacheItems() {
    List<ItemModel> temp = _collection.items;
    // filter query
    Map<String, RegExp> reQueries = {};
    for (MapEntry entry in filter.query.entries) {
      reQueries[entry.key] = RegExp(entry.value, caseSensitive: false);
    }
    if (filter.query.isNotEmpty) {
      temp = temp.where((item) {
        for (MapEntry<String, RegExp> re in reQueries.entries) {
          if (re.value.hasMatch(item[re.key].toString())) return true;
        }
        return false;
      }).toList();
    }
    // search
    if (_search.length > 1) {
      RegExp reSearch = RegExp(_search, caseSensitive: false);
      temp = temp.where((item) {
        for (FieldModel fieldSearch in fieldsSearch) {
          if (reSearch.hasMatch(item[fieldSearch.id].toString())) return true;
        }
        return false;
      }).toList();
    }
    // filter sort
    String sortField = filter.sort.field;
    temp.sort((a, b) => a[sortField].compareTo(b[sortField]));
    // filter reverse
    if (filter.sort.reverse) {
      temp = temp.reversed.toList();
    }
    _items = temp;
  }

  randomItem() {
    ItemModel item = _items[Random().nextInt(_items.length)];
    return item;
  }

  // search

  String get search => _search;
  set search(String search) {
    _search = search;
    _cacheItems();
    notifyListeners();
  }

  // id

  String get id => _collection.id;

  // template

  String get template => _collection.template;
  set template(String template) {
    _collection.template = template;
    notifyListeners();
  }

  // fields

  List<FieldModel> get fields => _collection.fields;
  set fields(List<FieldModel> fields) {
    _collection.fields = fields;
    notifyListeners();
  }

  // filter

  FilterModel get filter => _collection.filters.firstWhere((f) => f.id == _collection.filter, orElse: () => _collection.filters.first);
  set filter(FilterModel filter) {
    _search = '';
    _collection.filter = filter.id;
    _cacheItems();
    notifyListeners();
    saveCollection();
  }

  // filters

  List<FilterModel> get filters => _collection.filters;
  set filters(List<FilterModel> filters) {
    _collection.filters = filters;
    notifyListeners();
  }

  // importers

  List<ImporterModel> get importers => _collection.importers;
  set importers(List<ImporterModel> importers) {
    _collection.importers = importers;
    notifyListeners();
  }

  // storage

  Future<void> loadCollection(String collectionId) async {
    _collection = await storage.load(collectionId);
    _search = '';
    _cacheFields();
    _cacheLookups();
    _cacheItems();
    _cacheItemIds();
    notifyListeners();
  }

  Future<void> saveCollection() async {
    _cacheFields();
    _cacheLookups();
    _cacheItems();
    _cacheItemIds();
    await storage.save(_collection);
  }

  // storage items

  saveItem(String oldUid, ItemModel newItem) async {
    // update modified
    String now = DateTime.now().toIso8601String();
    newItem['modified'] = now;

    // find old item
    int oldItemIndex = _collection.items.indexWhere((a) => oldUid == a['uid']);

    // images
    for (FieldModel field in _collection.fields) {
      if (field.type == FieldType.image) {
        String fieldId = field.id;
        // if new image is url, save it
        String newImage = newItem[fieldId];
        bool isValidUrl = Uri.parse(newImage).host.isNotEmpty;
        if (isValidUrl) {
          String imagePath = await storage.addImage(_collection.id, fieldId, newItem['uid'], newImage);
          if (imagePath.isEmpty) {
            debugPrint('Failed to save image');
          }
          newItem[fieldId] = imagePath;
        }
        // remove old image
        if (oldItemIndex > -1) {
          ItemModel oldItem = _collection.items[oldItemIndex];
          String oldImage = oldItem[fieldId] ?? '';
          if (oldImage != newImage) {
            if (oldImage.isNotEmpty) {
              if (!await storage.removeImage(oldImage)) throw 'Failed to remove old image';
            }
          }
        }
      }
    }

    // replace / add item
    if (oldItemIndex > -1) {
      _collection.items[oldItemIndex] = newItem;
    } else {
      _collection.items.add(newItem);
    }

    await saveCollection();
    notifyListeners();
  }

  removeItem(ItemModel item) async {
    // remove images
    for (FieldModel field in _collection.fields) {
      if (field.type == FieldType.image) {
        String image = item[field.id];
        if (!await storage.removeImage(image)) throw 'Failed to remove old image';
      }
    }

    // remove item
    int i = _collection.items.indexWhere((a) => item['uid'] == a['uid']);
    if (i > -1) {
      _collection.items.removeAt(i);
      await saveCollection();
    }

    notifyListeners();
  }
}
