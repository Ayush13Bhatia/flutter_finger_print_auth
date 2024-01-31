import 'package:shared_preferences/shared_preferences.dart';

/// A Storage for maintaining the flags and login history
class SharedPrefUtils {
  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  /// call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance ?? await SharedPreferences.getInstance();
  }

  static dynamic getValue(String key, {dynamic defValue, bool isInt = false, bool isBool = false}) {
    if (isBool) return _prefsInstance?.getBool(key) ?? defValue ?? false;
    if (isInt) return _prefsInstance?.getInt(key) ?? defValue ?? 0;
    return _prefsInstance?.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setValue(String key, dynamic value, {bool isInt = false, bool isBool = false}) async {
    var prefs = await _instance;
    if (isBool) return await _prefsInstance?.setBool(key, value) ?? false;
    if (isInt) return await _prefsInstance?.setInt(key, value) ?? false;
    return prefs.setString(key, value);
  }

  static Future<bool> clear() async {
    return (await _prefsInstance?.clear()) ?? true;
  }

  void write(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      prefs.setString(key, value);
    }
  }

  static Future<dynamic> read(String key, {bool isInt = false, bool isBool = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (isInt) return prefs.getInt(key) ?? 0;
    if (isBool) return prefs.getBool(key) ?? false;
    return prefs.getString(key) ?? "";
  }

  Future<bool> clearPref() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  static Future<bool> deleteKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
