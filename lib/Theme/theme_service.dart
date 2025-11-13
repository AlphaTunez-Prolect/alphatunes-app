import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String themeKey = 'isDarkMode';

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false;
  }

  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeKey, isDarkMode);
  }

}





