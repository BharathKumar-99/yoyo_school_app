import 'package:shared_preferences/shared_preferences.dart';
import 'package:yoyo_school_app/config/constants/constants.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  SharedPrefsService._();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs?.setBool(Constants.kPermissionKey, false);
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("SharedPrefsService not initialized. Call init() first.");
    }
    return _prefs!;
  }
}
