import 'package:alpha_tunze/exports.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/Navigation.dart';
import '../screens/home.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add the missing _saveUserData method
  Future<void> _saveUserData({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_first_name', firstName);
    await prefs.setString('user_last_name', lastName);
    await prefs.setString('user_email', email);
    await prefs.setBool('is_logged_in', true); // Important: Mark user as logged in

    print('✅ User data saved locally: $firstName $lastName - $email');
  }

  Future<void> signUpUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('https://openauthzero.myf2.net/openauthzero/user/signup');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);

        final message = data['message'];
        final mailSent = data['mailsent'];
        final status = data['status'];

        // Save user data locally AFTER successful registration
        await _saveUserData(
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

        // Also save additional data if available from response
        if (data['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          final user = data['user'];
          if (user['id'] != null) {
            await prefs.setString('user_id', user['id'].toString());
          }
        }

        // Save token if available
        if (data['token'] != null || data['access_token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token'] ?? data['access_token']);
        }

        showSimpleNotification(
          Text(message ?? 'Registration successful!'),
          background: Colors.green,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );

        print('✅ Sign up successful: $data');
      } else {
        final errorData = convert.jsonDecode(response.body);
        showSimpleNotification(
          Text(errorData['message'] ?? "Sign up failed: ${response.reasonPhrase}"),
          background: Colors.red,
        );
        print('❌ Failed to sign up: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      showSimpleNotification(
        Text("Error: ${e.toString()}"),
        background: Colors.red,
      );
      print('⚠️ Error occurred: $e');
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
                  const SizedBox(height: 35),
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white), // Changed to white for visibility
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register Header
                  Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      color: Colors.white, // Made more visible
                      fontSize: 24, // Increased size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 25),

                  CustomInputField(
                    hint: "First Name",
                    isPassword: false,
                    controller: _firstNameController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),

                  CustomInputField(
                    hint: "Last Name",
                    isPassword: false,
                    controller: _lastNameController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),

                  CustomInputField(
                    hint: "Email",
                    isPassword: false,
                    controller: _emailController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),

                  CustomInputField(
                    hint: "Password",
                    isPassword: true,
                    controller: _passwordController,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Recover Password",
                        style: GoogleFonts.poppins(
                          color: Colors.pinkAccent,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: () {
                      // Add validation
                      if (_firstNameController.text.trim().isEmpty ||
                          _lastNameController.text.trim().isEmpty ||
                          _emailController.text.trim().isEmpty ||
                          _passwordController.text.trim().isEmpty) {
                        showSimpleNotification(
                          Text("Please fill in all fields"),
                          background: Colors.orange,
                        );
                        return;
                      }

                      signUpUser(
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    ),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider with OR
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

                  // Social Media Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton("assets/icons/google.png"),
                      const SizedBox(width: 20),
                      _buildSocialButton("assets/icons/apple.png"),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Already have account link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to SignIn
                        },
                        child: Text(
                          "Sign In",
                          style: GoogleFonts.poppins(
                            color: Colors.pinkAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
        // Implement social registration
      },
      child: Image.asset(asset, height: 40),
    );
  }
}