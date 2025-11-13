import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../const/images_string.dart';
import '../../widgets/customeinputfield.dart';
import '../../widgets/logo.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ResetpasswordScreen extends StatelessWidget {
  final String email;
  final TextEditingController _evCodeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ResetpasswordScreen({required this.email});

  Future<bool> ResetPassword({
    required String email,
    required String evCode,
    required String newPassword,
  }) async {
    final url = Uri.parse('https://openauthzero.myf2.net/openauthzero/user/resetpass');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode({
          'email': email,
          'evcode': evCode,
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);
        print('✅ Password reset successful: $data');
        return true;
      } else {
        print('❌ Failed to reset password: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Error occurred: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

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
                  const SizedBox(height: 10),

                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 35),
                        Logo(
                          assetPath: AppImages.AppLogo,
                          width: 200,
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reset Password Header
                  Text(
                    "Reset Password",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    "Check your email for the reset code",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  // Email Code Input
                  CustomInputField(
                    hint: "Enter Reset Code (evcode)",
                    isPassword: false,
                    controller: _evCodeController,
                    onChanged: (value) {
                      // Handle code input changes
                    },
                  ),

                  const SizedBox(height: 15),

                  // New Password Input
                  CustomInputField(
                    hint: "New Password",
                    isPassword: true,
                    controller: _newPasswordController,
                    onChanged: (value) {
                      // Handle password input changes
                    },
                  ),

                  const SizedBox(height: 15),

                  // Confirm Password Input
                  CustomInputField(
                    hint: "Confirm Password",
                    isPassword: true,
                    controller: _confirmPasswordController,
                    onChanged: (value) {
                      // Handle password input changes
                    },
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 20),

                  // Continue Button
                  ElevatedButton(
                    onPressed: () async {
                      // Validation
                      if (_evCodeController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⚠️ Please enter the reset code'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      if (_newPasswordController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⚠️ Please enter a new password'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      if (_newPasswordController.text.trim() !=
                          _confirmPasswordController.text.trim()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Passwords do not match'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_newPasswordController.text.trim().length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⚠️ Password must be at least 6 characters'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.pinkAccent,
                          ),
                        ),
                      );

                      // Call the reset password function
                      bool success = await ResetPassword(
                        email: email,
                        evCode: _evCodeController.text.trim(),
                        newPassword: _newPasswordController.text.trim(),
                      );

                      // Close loading indicator
                      Navigator.pop(context);

                      // Show result to user
                      if (success) {
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✅ Password reset successful! Please sign in.'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 3),
                          ),
                        );

                        // Navigate back to sign in screen (pop twice to go back to login)
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ Failed to reset password. Check your code and try again.'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    ),
                    child: Text(
                      "Reset Password",
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

                  // Back to Sign In Link
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Remember your password?",
                  //       style: GoogleFonts.poppins(
                  //         color: Colors.white60,
                  //         fontSize: 14,
                  //       ),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //         Navigator.pop(context);
                  //       },
                  //       child: Text(
                  //         "Sign in",
                  //         style: GoogleFonts.poppins(
                  //           color: Colors.blueAccent,
                  //           fontSize: 14,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Social Media Button
  Widget _buildSocialButton(String asset) {
    return GestureDetector(
      onTap: () {},
      child: Image.asset(asset, height: 40),
    );
  }
}