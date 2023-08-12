import 'dart:io';

import 'package:flutter/material.dart';
import 'package:collector/models/item_model.dart';
import 'package:collector/models/field_model.dart';
import 'package:collector/providers/collection_provider.dart';
import 'package:collector/services/storage_service.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class ItemProvider with ChangeNotifier {
  String _oldUid = '';
  Set<String> _oldItemUids = {};
  bool _overwriting = false;
  List<FieldModel> _fields = [];
  ItemModel _item = {};

  // old uid
  String get oldUid => _oldUid;

  // overwriting

  bool get isOverwriting => _overwriting;

  // values

  String get id => _item['id'];
  String get uid => _item['uid'];
  setId(String newUid) {
    if (newUid != _oldUid) {
      _overwriting = _oldItemUids.contains(newUid);
    }
    _item['uid'] = newUid;
    notifyListeners();
  }

  ItemModel get() {
    if (_overwriting) {
      ItemModel uniqueItem = Map.from(_item);
      uniqueItem['uid'] += ' - ${DateTime.now().microsecondsSinceEpoch}';
      return uniqueItem;
    }
    return _item;
  }

  set(ItemModel newItem) {
    for (MapEntry entry in newItem.entries) {
      if (entry.key == 'uid') continue;
      _item[entry.key] = entry.value;
    }
    setId(newItem['uid']);
  }

  dynamic getValue(String key) => _item[key];
  setValue(String key, dynamic value) {
    if (key == 'uid') throw 'Use setUid() instead';
    _item[key] = value;
    notifyListeners();
  }

  // valid

  bool get isValid => _item['uid'].isNotEmpty;

  // markdown data

  ItemModel get markdownData {
    ItemModel mdd = Map.from(_item);
    for (FieldModel field in _fields) {
      dynamic value = mdd[field.id];
      if (value == null) {
        mdd.remove(field.id);
        continue;
      }
      switch (field.type) {
        case FieldType.image:
          if (value.isEmpty) {
            mdd.remove(field.id);
            break;
          }
          bool isValidUrl = Uri.parse(value).host.isNotEmpty;
          if (!isValidUrl) {
            String localPath = value.replaceFirst(':', Platform.pathSeparator);
            String imagePath = [storage.directory.path, localPath].join(Platform.pathSeparator);
            Uri uri = Uri.file(absolute(imagePath), windows: Platform.isWindows);
            value = uri.toString();
            mdd[field.id] = value;
          }
          break;
        case FieldType.list:
        case FieldType.tags:
        case FieldType.string:
        case FieldType.text:
        case FieldType.select:
        case FieldType.markdown:
        case FieldType.date:
        case FieldType.datetime:
          if (value.isEmpty) mdd.remove(field.id);
          break;
        default:
          break;
      }
    }
    return mdd;
  }

  // storage

  create(String newItemId, CollectionProvider providerCollection) {
    _oldUid = '';
    _oldItemUids = providerCollection.itemUids;
    _fields = providerCollection.fields;

    String now = DateTime.now().toIso8601String();
    _item = {};

    for (FieldModel field in _fields) {
      _item[field.id] = field.defaultValue;
    }

    _item['uid'] = uuid.v4();
    _item['id'] = newItemId;
    _item['created'] = now;
    _item['modified'] = now;

    notifyListeners();
  }

  load(CollectionProvider providerCollection, ItemModel oldItem) async {
    _oldItemUids = providerCollection.itemUids;
    _fields = providerCollection.fields;
    _oldUid = oldItem['uid'];
    _item = Map.from(oldItem);
    notifyListeners();
  }
}
