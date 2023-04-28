import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hoard/models/artifact_model.dart';
import 'package:hoard/models/field_model.dart';
import 'package:hoard/providers/pile_provider.dart';
import 'package:hoard/services/storage_service.dart';
import 'package:path/path.dart';

class ArtifactProvider with ChangeNotifier {
  String _oldId = '';
  Set<String> _oldArtifactIds = {};
  bool _overwriting = false;
  List<FieldModel> _fields = [];
  ArtifactModel _artifact = {};

  // old id
  String get oldId => _oldId;

  // overwriting

  bool get isOverwriting => _overwriting;

  // values

  String get id => _artifact['id'];
  setId(String newId) {
    if (newId != _oldId) {
      _overwriting = _oldArtifactIds.contains(newId);
    }
    _artifact['id'] = newId;
    notifyListeners();
  }

  ArtifactModel get() {
    if (_overwriting) {
      ArtifactModel uniqueArtifact = Map.from(_artifact);
      uniqueArtifact['id'] += ' - ${DateTime.now().microsecondsSinceEpoch}';
      return uniqueArtifact;
    }
    return _artifact;
  }

  set(ArtifactModel newArtifact) {
    for (MapEntry entry in newArtifact.entries) {
      if (entry.key == 'id') continue;
      _artifact[entry.key] = entry.value;
    }
    setId(newArtifact['id']);
  }

  dynamic getValue(String key) => _artifact[key];
  setValue(String key, dynamic value) {
    if (key == 'id') throw 'Use setId() instead';
    _artifact[key] = value;
    notifyListeners();
  }

  // valid

  bool get isValid => _artifact['id'].isNotEmpty;

  // markdown data

  ArtifactModel get markdownData {
    ArtifactModel mdd = Map.from(_artifact);
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

  create(String newArtifactId, PileProvider providerPile) {
    _oldId = '';
    _oldArtifactIds = providerPile.artifactIds;
    _fields = providerPile.fields;

    String now = DateTime.now().toIso8601String();
    _artifact = {};

    for (FieldModel field in _fields) {
      _artifact[field.id] = field.defaultValue;
    }

    _artifact['id'] = newArtifactId;
    _artifact['created'] = now;
    _artifact['modified'] = now;

    notifyListeners();
  }

  load(PileProvider providerPile, ArtifactModel oldArtifact) async {
    _oldArtifactIds = providerPile.artifactIds;
    _fields = providerPile.fields;
    _oldId = oldArtifact['id'];
    _artifact = Map.from(oldArtifact);
    notifyListeners();
  }
}
