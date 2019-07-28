import 'package:shared_preferences/shared_preferences.dart';

class DataUtil {
  static saveData(String k, String v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(k, v);
  }

  static getData(String k) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.get(k);
  }
}
