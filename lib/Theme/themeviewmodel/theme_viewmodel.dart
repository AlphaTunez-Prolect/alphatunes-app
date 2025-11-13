import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class ThemeViewModel extends BaseViewModel {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? theme = prefs.getString('themeMode');

      if (theme == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (theme == 'light') {
        _themeMode = ThemeMode.light;
      } else {
        _themeMode = ThemeMode.system;
      }

      notifyListeners();
    } catch (e) {
      print("Error loading theme: $e");
    }
  }

  Future<void> toggleTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.light;
        await prefs.setString('themeMode', 'light');
      } else {
        _themeMode = ThemeMode.dark;
        await prefs.setString('themeMode', 'dark');
      }

      notifyListeners();
    } catch (e) {
      print("Error toggling theme: $e");
    }
  }
}
