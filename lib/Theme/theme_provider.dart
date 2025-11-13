

import 'package:alpha_tunze/Theme/theme.dart';
import 'package:alpha_tunze/exports.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themedata) {
    _themeData = themedata;
    notifyListeners();
  }

  void  toggleTheme () {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
}



}