import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  bool _isLoggedIn = false;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;
  String get fullName => '$_firstName $_lastName';

  // Load user data from SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _firstName = prefs.getString('user_first_name') ?? '';
    _lastName = prefs.getString('user_last_name') ?? '';
    _email = prefs.getString('user_email') ?? '';
    _isLoggedIn = _firstName.isNotEmpty || _lastName.isNotEmpty;
    notifyListeners();
  }

  // Set user data and save to SharedPreferences
  Future<void> setUserData({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_first_name', firstName);
    await prefs.setString('user_last_name', lastName);
    await prefs.setString('user_email', email);

    notifyListeners();
  }

  // Clear user data (logout)
  Future<void> clearUserData() async {
    _firstName = '';
    _lastName = '';
    _email = '';
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }
}