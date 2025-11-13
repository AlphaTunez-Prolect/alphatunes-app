import 'package:alpha_tunze/exports.dart';


class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.background, // Set background color
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), // Dark overlay with 50% opacity
                BlendMode.darken,
              ),
              child: Image.asset(
                'assets/prosper.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content (Logo, Text, Button)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo

                SizedBox(height: 35),


                Image.asset(
                  'assets/logoside.png',
                  width: 200, // Adjust logo width
                  height: 150, // Adjust logo height
                ),
                Spacer(),
                Text(
                  'Listen To Uplifting Music.',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:  Colors.white, // Customize text color
                  ),
                ),
                SizedBox(height: 20,),
            Text('Alphatunez® is a proprietary music streaming service for Gospel music and messages. ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,

                   ),
              textAlign: TextAlign.center,

            ),
                SizedBox(height: 40,),


                SizedBox(height: 20,),

                Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SizedBox(
                    height: 63,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add navigation or action here
                        // print('Get Started Button Pressed');

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Color(0xFFE40683),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ),
                  ),

SizedBox(width: 20,),

                  SizedBox(
                    height: 63,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add navigation or action here
                        // print('Get Started Button Pressed');

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Text color
                        ),
                      ),
                    ),
                  ),
                ],),
                SizedBox(height: 95), // Spacing between text and button
              ],
            ),
          ),
        ],
      ),
    );
  }
}