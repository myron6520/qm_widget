import 'package:shared_preferences/shared_preferences.dart';

class StorageManage {
  StorageManage._();
  static StorageManage? _instance;

  static StorageManage instance() {
    _instance ??= StorageManage._();
    return _instance!;
  }

  factory StorageManage() => instance();
  SharedPreferences? _sharedPreferences;
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setString(String key, String value) {
    _sharedPreferences?.setString(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }

  void setInt(String key, int value) {
    _sharedPreferences?.setInt(key, value);
  }

  int? getInt(String key) {
    return _sharedPreferences?.getInt(key);
  }

  void setDouble(String key, double value) {
    _sharedPreferences?.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _sharedPreferences?.getDouble(key);
  }

  void setBool(String key, bool value) {
    _sharedPreferences?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _sharedPreferences?.getBool(key);
  }

  void setStringList(String key, List<String> value) {
    _sharedPreferences?.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _sharedPreferences?.getStringList(key);
  }

  void clear() {
    _sharedPreferences?.clear();
  }

  void remove(String key) {
    _sharedPreferences?.remove(key);
  }

  void removeWithKeys(List<String> keys) {
    for (String key in keys) {
      _sharedPreferences?.remove(key);
    }
  }
}
