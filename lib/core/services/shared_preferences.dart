import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs.internal();
  factory SharedPrefs() => _instance;
  SharedPrefs.internal();

  SharedPreferences? prefs;

  // ignore: missing_return
  Future removeAll() async {
    prefs = await SharedPreferences.getInstance();

    prefs?.clear();
  }

  Future<void> setLocalStorage(String key, String value) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setString(key, value);
  }

  Future<String> getLocalStorage(String key) async {
    prefs = await SharedPreferences.getInstance();

    if (prefs?.get(key) == null) {
      return '';
    } else {
      return prefs?.get(key) as String;
    }
  }
}
