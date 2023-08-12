import 'dart:convert';
import 'package:collector/models/importer_model.dart';
import 'package:collector/widgets/item/importer_workers/importer_worker.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:collector/config.dart';

const String version = '3.0';

final String idIGDB = dotenv.env['IGDB_ID']!;
final String secretIGDB = dotenv.env['IGDB_SECRET']!;

const cacheToken = 'IGDB:Token';

class ImporterWorkerIGDB extends ImporterWorker {
  Future<String> getToken(bool retry) async {
    if (!config.has(cacheToken) || retry) {
      Uri uri = Uri.parse('https://id.twitch.tv/oauth2/token?client_id=$idIGDB&client_secret=$secretIGDB&grant_type=client_credentials');
      Response response = await post(uri);
      Map json = jsonDecode(utf8.decode(response.bodyBytes));
      config.set(cacheToken, json['access_token']);
    }
    return config.get(cacheToken);
  }

  Future<dynamic> api({required String url, required String body, retry = false}) async {
    try {
      final String token = await getToken(retry);
      Response response = await post(
        Uri.parse(url),
        headers: {
          'Client-ID': idIGDB,
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      if (response.statusCode != 200) {
        if (retry) {
          throw Exception('IGDB Error: ${response.statusCode}');
        }
        return api(url: url, body: body, retry: true);
      }
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
  Future<ImportingModel> fetch(Map ref) async {
    List results = await api(
      url: 'https://api.igdb.com/v4/games',
      body: 'fields aggregated_rating, cover.*, first_release_date, genres.*, name, platforms.*, summary, url; where id=${ref['id']};',
    );
    Map result = results.first;
    ImportingModel importing = {};

    // ID
    try {
      importing['id'] = result['name'];
    } catch (e) {
      // ignore: avoid_print
      print("result['name'] $result");
    }

    // Image
    try {
      importing['image'] = 'https:${result['cover']['url'].replaceAll('t_thumb', 't_cover_big')}';
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] $result");
    }

    // Year
    try {
      importing['year'] = DateTime.fromMillisecondsSinceEpoch(result['first_release_date'] * 1000).year.toString();
    } catch (e) {
      // ignore: avoid_print
      print("result['cover']['url'] $result");
    }

    // Platforms
    try {
      importing['platforms'] = result['platforms'].map((platform) => platform['name']).toList();
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
      importing['website'] = result['url'];
    } catch (e) {
      // ignore: avoid_print
      print("result['url'] $result");
    }

    // Rating
    try {
      importing['rating'] = result['aggregated_rating'].round().toString();
    } catch (e) {
      // ignore: avoid_print
      print("result['aggregated_rating'] $result");
    }

    // Description
    try {
      importing['description'] = result['summary'];
    } catch (e) {
      // ignore: avoid_print
      print("result['summary'] $result");
    }

    // Importer
    importing['importer'] = 'IGDB $version ${DateTime.now().toIso8601String()}';

    return importing;
  }
}
