import 'dart:convert';
import 'package:hoard/models/forge_model.dart';
import 'package:hoard/widgets/artifact/forge_workers/forge_worker.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String version = '2.0';
final String keyRAWG = dotenv.env['RAWG']!;

class ForgeWorkerRAWG extends ForgeWorker {
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
  Future<ForgingModel> fetch(Map ref) async {
    Uri uri = Uri.parse('https://api.rawg.io/api/games/${ref['id']}?key=$keyRAWG');
    Response response = await get(uri);
    Map result = jsonDecode(utf8.decode(response.bodyBytes));
    ForgingModel forging = {};

    // Title
    try {
      forging['id'] = result['name'];
    } catch (e) {
      // ignore: avoid_print
      print("result['name'] ${result['name']}");
    }

    // Image
    try {
      forging['image'] = result['background_image'];
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] ${result['cover']['url']}");
    }

    // Year
    try {
      forging['year'] = DateTime.parse(result['released']).year.toString();
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] $result['cover']['url']");
    }

    // Platforms
    try {
      forging['platforms'] = result['platforms'].map((platform) => platform['platform']['name']).toList();
    } catch (e) {
      // ignore: avoid_print
      print("result['platforms'] ${result['platforms']}");
    }

    // Genres
    try {
      forging['genres'] = result['genres'].map((genre) => genre['name']).toList();
    } catch (e) {
      // ignore: avoid_print
      print("result['genres'] ${result['genres']}");
    }

    // Website
    try {
      forging['website'] = 'https://rawg.io/games/${result['slug']}';
    } catch (e) {
      // ignore: avoid_print
      print("result['url'] ${result['url']}");
    }

    // Rating
    try {
      forging['rating'] = result['metacritic'].toString();
    } catch (e) {
      // ignore: avoid_print
      print("result['aggregated_rating'] ${result['aggregated_rating']}");
    }

    // Description
    try {
      forging['description'] = result['description_raw'];
    } catch (e) {
      // ignore: avoid_print
      print("result['summary'] ${result['summary']}");
    }

    // Forge
    forging['forge'] = 'RAWG $version ${DateTime.now().toIso8601String()}';

    return forging;
  }
}
