import 'package:alpha_tunze/exports.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';

import '../screens/Navigation.dart';
import '../screens/home.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveUserData({
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

  // Fetch user profile data after successful login
  Future<void> _fetchUserProfile(String email) async {
    try {
      final url = Uri.parse('https://openauthzero.myf2.net/openauthzero/user/profile');
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
        final user = data['user'] ?? data;

        await _saveUserData(
          email: email,
          firstName: user['firstname'] ?? user['first_name'],
          lastName: user['lastname'] ?? user['last_name'],
          token: data['token'] ?? data['access_token'],
          userId: user['id']?.toString(),
        );
      }
    } catch (e) {
      print('Failed to fetch user profile: $e');
      // Still save basic info if profile fetch fails
      await _saveUserData(email: email);
    }
  }

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://openauthzero.myf2.net/openauthzero/user/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);

        final message = data['message'];
        final mailSent = data['mailsent'];
        final status = data['status'];

        // Check if the response contains user data
        if (data['user'] != null) {
          // If user data is included in login response
          final user = data['user'];
          await _saveUserData(
            email: email,
            firstName: user['firstname'] ?? user['first_name'],
            lastName: user['lastname'] ?? user['last_name'],
            token: data['token'] ?? data['access_token'],
            userId: user['id']?.toString(),
          );
        } else {
          // If no user data in response, fetch it separately
          await _fetchUserProfile(email);
        }

        showSimpleNotification(
          Text(message ?? "Login successful!"),
          background: Colors.green,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationScreen()),
        );
      } else if (response.statusCode == 401) {
        showSimpleNotification(
          Text("Invalid credentials. Please check your email and password."),
          background: Colors.red,
        );
      } else {
        final errorData = convert.jsonDecode(response.body);
        showSimpleNotification(
          Text(errorData['message'] ?? "Login failed: ${response.reasonPhrase}"),
          background: Colors.red,
        );
      }
    } catch (e) {
      showSimpleNotification(
        Text("Error: ${e.toString()}"),
        background: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Color(0xFF220D31)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(width: 35),
                        // Add your logo here if needed
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Sign In",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 60),
                  CustomInputField(
                    hint: "Enter your email",
                    isPassword: false,
                    controller: _emailController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),
                  CustomInputField(
                    hint: "Enter your password",
                    isPassword: true,
                    controller: _passwordController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          "Forgot Password",
                          style: GoogleFonts.poppins(
                            color: Colors.pinkAccent,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        showSimpleNotification(
                          Text("Please fill in both email and password."),
                          background: Colors.red,
                        );
                        return;
                      }

                      signInUser(email: email, password: password);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 100),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Sign In",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Or",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton("assets/icons/google.png"),
                      const SizedBox(width: 20),
                      _buildSocialButton("assets/icons/apple.png"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not A Member ?",
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          "Register Now",
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String asset) {
    return GestureDetector(
      onTap: () {
        // Implement social login
      },
      child: Image.asset(asset, height: 40),
    );
  }
}