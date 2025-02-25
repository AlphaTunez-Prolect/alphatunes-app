import 'package:alpha_tunze/exports.dart';


class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      // appBar: AppBar(
      //
      // ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Color(0xFF220D31)], // Dark gradient
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
                        ), SizedBox(width: 35,),
                        Logo(assetPath:AppImages.AppLogo,
                          width: 200, height: 150,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign In Header
                  Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 25),
                  // Username Input
                  // _buildInputField("Enter Username Or Email", false),
                  CustomInputField(
                    hint: "Full Name",
                    isPassword: false,
                    controller: _emailController,
                    onChanged: (value) {
                      // Handle email input changes
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomInputField(
                    hint: "Enter Email",
                    isPassword: false,
                    controller: _emailController,
                    onChanged: (value) {
                      // Handle email input changes
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomInputField(
                    hint: "Mobile Number",
                    isPassword: false,
                    controller: _emailController,
                    onChanged: (value) {
                      // Handle email input changes
                    },
                  ),
                  const SizedBox(height: 15),
                  // Password Input
                  // _buildInputField("Password", true),

                  CustomInputField(
                    hint: "Password",
                    isPassword: true,
                    controller: _passwordController,
                    onChanged: (value) {
                      // Handle password input changes
                    },
                  ),
                  const SizedBox(height: 15),

                  CustomInputField(
                    hint: "Confirm Password",
                    isPassword: true,
                    controller: _passwordController,
                    onChanged: (value) {
                      // Handle password input changes
                    },
                  ),
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

                  // Sign In Button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    ),
                    child: Text(
                      "Sign In",
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
                      _buildSocialButton("assets/icons/google.png"), // Replace with actual asset
                      const SizedBox(width: 20),
                      _buildSocialButton("assets/icons/apple.png"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Register Now",
                          style: GoogleFonts.poppins(
                            color: Colors.blueAccent,
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


  // Social Media Button
  Widget _buildSocialButton(String asset) {
    return GestureDetector(
      onTap: () {},
      child: Image.asset(asset, height: 40),
    );
  }
}
