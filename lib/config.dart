import 'package:shared_preferences/shared_preferences.dart';

late Config config;

class Config {
  final SharedPreferences sp;

  Config(this.sp);

  bool has(String key) {
    return sp.containsKey(key);
  }

  String get(String key) {
    return sp.getString(key) ?? '';
  }

  Future<void> set(String key, String value) async {
    await sp.setString(key, value);
  }

  Future<void> remove(String key) async {
    await sp.remove(key);
  }
}

Future<void> cacheInit() async {
  // instance
  config = Config(await SharedPreferences.getInstance());
  // defaults
  if (!config.has('mode')) await config.set('mode', 'tall');
}
