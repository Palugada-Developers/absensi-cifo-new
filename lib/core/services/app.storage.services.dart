import 'package:shared_preferences/shared_preferences.dart';

class AppStorageServices {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<String?> getData(String key) async {
    try {
      final prefs = await _sharedPreferences;
      final data = prefs.getString(key);

      return data;
    } catch (e){
      return null;
    }
  }

  Future<bool> saveData(String key, dynamic data) async {
    try {
      final prefs = await _sharedPreferences;
      await prefs.setString(key, data as String);
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<void> removeData(String key) async {
    try {
      final prefs = await _sharedPreferences;
      await prefs.remove(key);
    } catch (e) {
      throw Error();
    }
  }

  Future<void> removeAllData() async {
    try {
      final prefs = await _sharedPreferences;
      await prefs.clear();
    } catch (e) {
      throw Error();
    }
  }
}