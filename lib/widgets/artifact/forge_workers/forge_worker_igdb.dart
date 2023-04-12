import 'dart:convert';
import 'package:hoard/models/forge_model.dart';
import 'package:hoard/widgets/artifact/forge_workers/forge_worker.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hoard/config.dart';

const String version = '2.0';

final String idIGDB = dotenv.env['IGDB_ID']!;
final String secretIGDB = dotenv.env['IGDB_SECRET']!;

const cacheToken = 'IGDB:Token';

class ForgeWorkerIGDB extends ForgeWorker {
  Future<String> getToken() async {
    if (!config.has(cacheToken)) {
      Uri uri = Uri.parse('https://id.twitch.tv/oauth2/token?client_id=$idIGDB&client_secret=$secretIGDB&grant_type=client_credentials');
      Response response = await post(uri);
      Map json = jsonDecode(utf8.decode(response.bodyBytes));
      config.set(cacheToken, json['access_token']);
    }
    return config.get(cacheToken);
  }

  Future<dynamic> api({required String url, required String body}) async {
    try {
      final String token = await getToken();
      Response response = await post(
        Uri.parse(url),
        headers: {
          'Client-ID': idIGDB,
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (error) {
      // ignore: avoid_print
      print('Games IGDB api $error');
      return [];
    }
  }

  @override
  Future<List<Map>> search(String query) async {
    List data = await api(
      url: 'https://api.igdb.com/v4/games',
      body: 'fields id, name, first_release_date; search "$query"; limit 100;',
    );
    String id;
    String label;
    List<Map> results = List.from(data.map((item) {
      id = item['name'];
      label = item['name'];
      try {
        label += ' (${DateTime.fromMillisecondsSinceEpoch(item['first_release_date'] * 1000).year})';
      } catch (e) {
        // silently fail
      }
      return {'id': id, 'label': label, 'ref': item};
    }));
    return results;
  }

  @override
  Future<ForgingModel> fetch(Map ref) async {
    List results = await api(
      url: 'https://api.igdb.com/v4/games',
      body: 'fields aggregated_rating, cover.*, first_release_date, genres.*, name, platforms.*, summary, url; where id=${ref['id']};',
    );
    Map result = results.first;
    ForgingModel forging = {};

    // ID
    try {
      forging['id'] = result['name'];
    } catch (e) {
      // ignore: avoid_print
      print("result['name'] ${result['name']}");
    }

    // Image
    try {
      forging['image'] = 'https:${result['cover']['url'].replaceAll('t_thumb', 't_cover_big')}';
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] ${result['cover']['url']}");
    }

    // Year
    try {
      forging['year'] = DateTime.fromMillisecondsSinceEpoch(result['first_release_date'] * 1000).year.toString();
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] $result['cover']['url']");
    }

    // Platforms
    try {
      forging['platforms'] = result['platforms'].map((platform) => platform['name']).toList();
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
      forging['website'] = result['url'];
    } catch (e) {
      // ignore: avoid_print
      print("result['url'] ${result['url']}");
    }

    // Rating
    try {
      forging['rating'] = result['aggregated_rating'].round();
    } catch (e) {
      // ignore: avoid_print
      print("result['aggregated_rating'] ${result['aggregated_rating']}");
    }

    // Description
    try {
      forging['description'] = result['summary'];
    } catch (e) {
      // ignore: avoid_print
      print("result['summary'] ${result['summary']}");
    }

    // Scribe
    forging['scribe'] = 'IGDB $version ${DateTime.now().toIso8601String()}';

    return forging;
  }
}
