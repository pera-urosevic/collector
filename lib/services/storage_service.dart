import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:hoard/models/pile_model.dart';
import 'package:hoard/services/json_service.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class Storage {
  late Directory _directory;

  Directory get directory => _directory;

  Storage() {
    if (Platform.isAndroid) {
      _directory = Directory('/storage/emulated/0/Hoard');
      return;
    }
    if (Platform.isWindows) {
      _directory = Directory('${Platform.environment['USERPROFILE']}\\Hoard');
      return;
    }
  }

  Future<List<String>> list() async {
    List<String> pileIds = [];
    await for (FileSystemEntity entity in _directory.list(recursive: false)) {
      if (extension(entity.path) != '.json') continue;
      String name = basenameWithoutExtension(entity.path);
      pileIds.add(name);
    }
    pileIds.sort();
    return pileIds;
  }

  Future<void> save(PileModel pile) async {
    String filePath = '${_directory.path}${Platform.pathSeparator}${pile.id}.json';
    String contents = encode(pile);
    File(filePath).writeAsString(contents);
  }

  Future<PileModel> load(String pileId) async {
    String filePath = '${_directory.path}${Platform.pathSeparator}$pileId.json';
    String contents = await File(filePath).readAsString();
    PileModel pile = PileModel.fromJson(decode(contents));
    return pile;
  }

  Future<void> remove(String pileId) async {
    String filePath = '${_directory.path}${Platform.pathSeparator}$pileId.json';
    File(filePath).delete();
  }

  Future<String> addImage(String pileId, String url) async {
    var response = await get(Uri.parse(url));
    Image? image = decodeImage(response.bodyBytes);
    if (image == null) return '';
    if (image.height > image.width) {
      image = copyResize(image, height: 320);
    } else {
      image = copyResize(image, width: 320);
    }
    String key = uuid.v4();
    String imageField = '$pileId:$key.jpg';
    String imagePath = [pileId, '$key.jpg'].join(Platform.pathSeparator);
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
