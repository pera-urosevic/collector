import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hoard/models/artifact_model.dart';
import 'package:hoard/models/field_model.dart';
import 'package:hoard/models/filter_model.dart';
import 'package:hoard/models/forge_model.dart';
import 'package:hoard/models/pile_model.dart';
import 'package:hoard/services/storage_service.dart';

class PileProvider with ChangeNotifier {
  String _search = '';
  PileModel _pile = PileModel.blank('Blank');
  List<FieldModel> _fieldsIndex = [];
  List<FieldModel> _fieldsSearch = [];
  Map<String, List<String>> _lookups = {};
  Set<String> _artifactIds = {};
  List<ArtifactModel> _artifacts = [];

  // cache fields

  List<FieldModel> get fieldsIndex => _fieldsIndex;
  List<FieldModel> get fieldsSearch => _fieldsSearch;

  _cacheFields() {
    _fieldsIndex = _pile.fields.where((field) => field.index).toList();
    _fieldsSearch = _pile.fields.where((field) => field.search).toList();
  }

  // cache lookups

  Map<String, List<String>> get lookups => _lookups;

  _cacheLookups() {
    _lookups = {};
    for (FieldModel field in _pile.fields) {
      switch (field.type) {
        case FieldType.select:
          Set<String> set = {};
          for (ArtifactModel artifact in _pile.artifacts) {
            String value = artifact[field.id].toString();
            set.add(value);
          }
          _lookups[field.id] = set.toList();
          break;
        case FieldType.tags:
          Set<String> set = {};
          for (ArtifactModel artifact in _pile.artifacts) {
            List<String> values = List<String>.from(artifact[field.id].map((value) => value.toString()));
            set.addAll(values);
          }
          _lookups[field.id] = set.toList();
          break;
        default:
          break;
      }
    }
  }

  // cache artifacts

  Set<String> get artifactIds => _artifactIds;
  _cacheArtifactIds() {
    _artifactIds = Set.from(_pile.artifacts.map((artifact) => artifact['id']));
  }

  List<ArtifactModel> get artifacts => _artifacts;
  _cacheArtifacts() {
    List<ArtifactModel> temp = _pile.artifacts;
    // filter query
    Map<String, RegExp> reQueries = {};
    for (MapEntry entry in _pile.filter.query.entries) {
      reQueries[entry.key] = RegExp(entry.value, caseSensitive: false);
    }
    if (_pile.filter.query.isNotEmpty) {
      temp = temp.where((artifact) {
        for (MapEntry<String, RegExp> re in reQueries.entries) {
          if (re.value.hasMatch(artifact[re.key].toString())) return true;
        }
        return false;
      }).toList();
    }
    // search
    if (_search.length > 1) {
      RegExp reSearch = RegExp(_search, caseSensitive: false);
      temp = temp.where((artifact) {
        for (FieldModel fieldSearch in fieldsSearch) {
          if (reSearch.hasMatch(artifact[fieldSearch.id].toString())) return true;
        }
        return false;
      }).toList();
    }
    // filter sort
    String sortField = _pile.filter.sort.field;
    temp.sort((a, b) => a[sortField].compareTo(b[sortField]));
    // filter reverse
    if (_pile.filter.sort.reverse) {
      temp = temp.reversed.toList();
    }
    _artifacts = temp;
  }

  randomArtifact() {
    ArtifactModel artifact = _artifacts[Random().nextInt(_artifacts.length)];
    return artifact;
  }

  // search

  String get search => _search;
  set search(String search) {
    _search = search;
    _cacheArtifacts();
    notifyListeners();
  }

  // id

  String get id => _pile.id;

  // template

  String get template => _pile.template;
  set template(String template) {
    _pile.template = template;
    notifyListeners();
  }

  // fields

  List<FieldModel> get fields => _pile.fields;
  set fields(List<FieldModel> fields) {
    _pile.fields = fields;
    notifyListeners();
  }

  // filter

  FilterModel get filter => _pile.filter;
  set filter(FilterModel filter) {
    _search = '';
    _pile.filter = filter;
    _cacheArtifacts();
    notifyListeners();
    savePile();
  }

  // filters

  List<FilterModel> get filters => _pile.filters;
  set filters(List<FilterModel> filters) {
    _pile.filters = filters;
    notifyListeners();
  }

  // forges

  List<ForgeModel> get forges => _pile.forges;
  set forges(List<ForgeModel> forges) {
    _pile.forges = forges;
    notifyListeners();
  }

  // storage

  Future<void> loadPile(String pileId) async {
    _pile = await storage.load(pileId);
    _cacheFields();
    _cacheLookups();
    _cacheArtifacts();
    _cacheArtifactIds();
    notifyListeners();
  }

  Future<void> savePile() async {
    _cacheFields();
    _cacheLookups();
    _cacheArtifacts();
    _cacheArtifactIds();
    await storage.save(_pile);
  }

  // storage artifacts

  saveArtifact(String oldId, ArtifactModel newArtifact) async {
    // update modified
    String now = DateTime.now().toIso8601String();
    newArtifact['modified'] = now;

    // find old artifact
    int oldArtifactIndex = _pile.artifacts.indexWhere((a) => oldId == a['id']);

    // images
    for (FieldModel field in _pile.fields) {
      if (field.type == FieldType.image) {
        String fieldId = field.id;
        // if new image is url, save it
        String newImage = newArtifact[fieldId];
        bool isValidUrl = Uri.parse(newImage).host.isNotEmpty;
        if (isValidUrl) {
          String imagePath = await storage.addImage(_pile.id, newImage);
          if (imagePath.isEmpty) {
            debugPrint('Failed to save image');
          }
          newArtifact[fieldId] = imagePath;
        }
        // remove old image
        if (oldArtifactIndex > -1) {
          ArtifactModel oldArtifact = _pile.artifacts[oldArtifactIndex];
          String oldImage = oldArtifact[fieldId];
          if (oldImage != newImage) {
            if (oldImage.isNotEmpty) {
              if (!await storage.removeImage(oldImage)) throw 'Failed to remove old image';
            }
          }
        }
      }
    }

    // replace / add artifact
    if (oldArtifactIndex > -1) {
      _pile.artifacts[oldArtifactIndex] = newArtifact;
    } else {
      _pile.artifacts.add(newArtifact);
    }

    await savePile();
    notifyListeners();
  }

  removeArtifact(ArtifactModel artifact) async {
    // remove images
    for (FieldModel field in _pile.fields) {
      if (field.type == FieldType.image) {
        String image = artifact[field.id];
        if (!await storage.removeImage(image)) throw 'Failed to remove old image';
      }
    }

    // remove artifact
    int i = _pile.artifacts.indexWhere((a) => artifact['id'] == a['id']);
    if (i > -1) {
      _pile.artifacts.removeAt(i);
      await savePile();
    }

    notifyListeners();
  }
}
