import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:collector/models/collection_model.dart';
import 'package:collector/services/json_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Storage {
  late Directory _directory;

  Directory get directory => _directory;

  Storage() {
    if (Platform.isAndroid) {
      _directory = Directory('/storage/emulated/0/Collector');
      return;
    }
    if (Platform.isWindows) {
      _directory = Directory('${Platform.environment['USERPROFILE']}\\Data\\Collector');
      return;
    }
  }

  Future<List<String>> list() async {
    List<String> collectionIds = [];
    await for (FileSystemEntity entity in _directory.list(recursive: false)) {
      if (extension(entity.path) != '.json') continue;
      String name = basenameWithoutExtension(entity.path);
      collectionIds.add(name);
    }
    collectionIds.sort();
    return collectionIds;
  }

  Future<void> save(CollectionModel collection) async {
    String filePath = '${_directory.path}${Platform.pathSeparator}${collection.id}.json';
    String contents = encode(collection);
    File(filePath).writeAsString(contents);
  }

  Future<CollectionModel> load(String collectionId) async {
    String filePath = '${_directory.path}${Platform.pathSeparator}$collectionId.json';
    String contents = await File(filePath).readAsString();
    CollectionModel collection = CollectionModel.fromJson(decode(contents));
    return collection;
  }

  Future<void> remove(String collectionId) async {
    String filePath = '${_directory.path}${Platform.pathSeparator}$collectionId.json';
    File(filePath).delete();
  }

  Future<String> addImage(String collectionId, String fieldId, String itemUid, String url) async {
    var response = await get(Uri.parse(url));
    Image? image = decodeImage(response.bodyBytes);
    if (image == null) return '';
    if (image.height > image.width) {
      image = copyResize(image, height: 320);
    } else {
      image = copyResize(image, width: 320);
    }
    String key = '$fieldId-$itemUid';
    String imageField = '$collectionId:$key.jpg';
    String imagePath = [collectionId, '$key.jpg'].join(Platform.pathSeparator);
    String filePath = [directory.path, imagePath].join(Platform.pathSeparator);
    File file = File(filePath);
    file.createSync(recursive: true);
    file.writeAsBytesSync(encodeJpg(image, quality: 70));
    return imageField;
  }

  Future<bool> removeImage(String imagePath) async {
    try {
      String filePath = [directory.path, imagePath].join(Platform.pathSeparator);
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

Storage storage = Storage();
