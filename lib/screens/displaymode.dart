import 'package:alpha_tunze/exports.dart';


class DisplaymodeScreen extends StatelessWidget {
  const DisplaymodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color
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
                'assets/yada.png',
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
                  'Choose mode',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white, // Customize text color
                  ),
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                [
                  SizedBox(
                    child: Container(
                      child: Column(
                        children: [
                          Image.asset('assets/icons/Sun 1.png',width: 50,),
                          Text('Dark mode',
                            style: TextStyle(
                              color: Colors.white,

                            ),

                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 55,),
                  SizedBox(
                    child: Container(
                      child: Column(
                        children: [
                          Image.asset('assets/icons/Moon.png',width: 50,),
                          Text('Dark mode',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                ),

                SizedBox(height: 20,),



                SizedBox(
                  height: 63,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add navigation or action here
                      // print('Get Started Button Pressed');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrationScreen()),
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
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Spacing between text and button

              ],
            ),
          ),
        ],
      ),
    );
  }
}