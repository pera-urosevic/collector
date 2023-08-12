import 'dart:convert';
import 'package:collector/models/importer_model.dart';
import 'package:collector/widgets/item/importer_workers/importer_worker.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String version = '3.0';
final String keyRAWG = dotenv.env['RAWG']!;

class ImporterWorkerRAWG extends ImporterWorker {
  @override
  Future<List<Map>> search(String query) async {
    Uri uri = Uri.parse('https://api.rawg.io/api/games?search=${query.toLowerCase()}&key=$keyRAWG');
    Response response = await get(uri);
    Map data = jsonDecode(utf8.decode(response.bodyBytes));
    String id;
    String label;
    List<Map> results = List.from(data['results'].map((item) {
      id = item['name'];
      label = item['name'];
      try {
        label += ' (${DateTime.parse(item['released']).year})';
      } catch (e) {
        // silently fail
      }
      return {'id': id, 'label': label, 'ref': item};
    }));
    return results;
  }

  @override
  Future<ImportingModel> fetch(Map ref) async {
    Uri uri = Uri.parse('https://api.rawg.io/api/games/${ref['id']}?key=$keyRAWG');
    Response response = await get(uri);
    Map result = jsonDecode(utf8.decode(response.bodyBytes));
    ImportingModel importing = {};

    // Title
    try {
      importing['id'] = result['name'];
    } catch (e) {
      // ignore: avoid_print
      print("result['name'] $result");
    }

    // Image
    try {
      importing['image'] = result['background_image'];
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] $result");
    }

    // Year
    try {
      importing['year'] = DateTime.parse(result['released']).year.toString();
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] $result");
    }

    // Platforms
    try {
      importing['platforms'] = result['platforms'].map((platform) => platform['platform']['name']).toList();
    } catch (e) {
      // ignore: avoid_print
      print("result['platforms'] $result");
    }

    // Genres
    try {
      importing['genres'] = result['genres'].map((genre) => genre['name']).toList();
    } catch (e) {
      // ignore: avoid_print
      print("result['genres'] $result");
    }

    // Website
    try {
      importing['website'] = 'https://rawg.io/games/${result['slug']}';
    } catch (e) {
      // ignore: avoid_print
      print("result['url'] $result");
    }

    // Rating
    try {
      importing['rating'] = result['metacritic'].toString();
    } catch (e) {
      // ignore: avoid_print
      print("result['aggregated_rating'] $result");
    }

    // Description
    try {
      importing['description'] = result['description_raw'];
    } catch (e) {
      // ignore: avoid_print
      print("result['summary'] $result");
    }

    // Importer
    importing['importer'] = 'RAWG $version ${DateTime.now().toIso8601String()}';

    return importing;
  }
}
