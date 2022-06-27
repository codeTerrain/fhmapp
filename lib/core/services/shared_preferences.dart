import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

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

  Future<bool?> containsKey(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs?.containsKey(key);
  }

  Future<void> setListLocalStorage(String key, List<String> value) async {
    prefs = await SharedPreferences.getInstance();
    prefs?.setStringList(key, value);
  }

  Future<String> getLocalStorage(String key) async {
    prefs = await SharedPreferences.getInstance();

    if (prefs?.get(key) == null) {
      return '';
    } else {
      return prefs?.get(key) as String;
    }
  }

  Future<List<String>?> getListLocalStorage(String key) async {
    prefs = await SharedPreferences.getInstance();

    if (prefs?.get(key) == null) {
      return [];
    } else {
      return prefs?.getStringList(key);
    }
  }

  Future removeEntry(String key) async {
    prefs = await SharedPreferences.getInstance();

    prefs?.remove(key);
  }

  setLocalUserData(Users user) {
    setLocalStorage('userId', user.userId);
    setLocalStorage('firstName', user.firstName);
    setLocalStorage('lastName', user.lastName);
    setLocalStorage('community', user.community ?? '');
    setLocalStorage('email', user.email);
    setLocalStorage('phone', user.phone);
    setLocalStorage('cadre', user.cadre);
    setLocalStorage('region', user.region);
    setLocalStorage('gender', user.gender);
    setLocalStorage('district', user.district);
    setLocalStorage('facility', user.facility);
    setLocalStorage('subDistrict', user.subDistrict ?? '');
    setLocalStorage('userType', user.userType);
    setLocalStorage(
        'dateJoined', user.dateJoined.millisecondsSinceEpoch.toString());
    setLocalStorage('dob', user.dob.millisecondsSinceEpoch.toString());
    setLocalStorage('profilePicture', user.profilePicture ?? '');
    setListLocalStorage('fhmappAdminFor', user.fhmappAdminFor ?? []);
    setLocalStorage('login', 'true');
  }
}
