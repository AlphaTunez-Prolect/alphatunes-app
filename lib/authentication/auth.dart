import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://openauthzero.myf2.net/openauthzero';

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final email = prefs.getString('user_email');

    return isLoggedIn && email != null;
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    final firstName = prefs.getString('user_first_name');
    final lastName = prefs.getString('user_last_name');
    final email = prefs.getString('user_email');
    final userId = prefs.getString('user_id');
    final token = prefs.getString('auth_token');

    if (email != null) {
      return {
        'firstName': firstName ?? '',
        'lastName': lastName ?? '',
        'email': email,
        'userId': userId ?? '',
        'token': token ?? '',
      };
    }

    return null;
  }

  // Refresh user data from server
  static Future<Map<String, dynamic>?> refreshUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    if (email == null) return null;

    try {
      // Try to get user profile using email
      final url = Uri.parse('$baseUrl/user/profile');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        final userData = data['user'] ?? data;

        // Update local storage with fresh data
        if (userData['firstname'] != null || userData['first_name'] != null) {
          await prefs.setString('user_first_name', userData['firstname'] ?? userData['first_name'] ?? '');
        }
        if (userData['lastname'] != null || userData['last_name'] != null) {
          await prefs.setString('user_last_name', userData['lastname'] ?? userData['last_name'] ?? '');
        }
        if (userData['email'] != null) {
          await prefs.setString('user_email', userData['email']);
        }

        return userData;
      }
    } catch (e) {
      print('Failed to refresh user data: $e');
    }

    return null;
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    // Optionally notify server about logout
    if (email != null) {
      try {
        final url = Uri.parse('$baseUrl/user/logout');
        await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: convert.jsonEncode({
            'email': email,
          }),
        );
      } catch (e) {
        print('Server logout failed: $e');
      }
    }

    // Clear all local data
    await prefs.clear();
  }

  // Update user profile
  static Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    if (email == null) return false;

    try {
      final url = Uri.parse('$baseUrl/user/update');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'email': email,
          'firstname': firstName,
          'lastname': lastName,
          if (profileImage != null) 'profile_image': profileImage,
        }),
      );

      if (response.statusCode == 200) {
        // Update local storage
        await prefs.setString('user_first_name', firstName);
        await prefs.setString('user_last_name', lastName);
        return true;
      }
    } catch (e) {
      print('Profile update failed: $e');
    }

    return false;
  }

  // Save user data locally (used by login/register)
  static Future<void> saveUserData({
    required String email,
    String? firstName,
    String? lastName,
    String? token,
    String? userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setBool('is_logged_in', true);

    if (firstName != null) await prefs.setString('user_first_name', firstName);
    if (lastName != null) await prefs.setString('user_last_name', lastName);
    if (token != null) await prefs.setString('auth_token', token);
    if (userId != null) await prefs.setString('user_id', userId);
  }
}